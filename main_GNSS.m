function [latitude, longitude] = main_GNSS(json_content)

%
addpath 'Corrections';
addpath 'Corrections/Control_segment';
addpath 'Corrections/Prop_Effects';
addpath 'Ephemeris';
addpath 'Misc';
addpath 'Observations';
addpath 'JSON';
    
%% Build struct from JSON
GNSS_info       = jsondecode(json_content);

%% Create acquisition struct from GNSS_info
acq_info        = extract_info(GNSS_info);

if acq_info.flags.constellations.GPS
    system  =   'GPS';
else
    system   =   'Galileo'; 
end

%% It is needed to download a navigation message to obtain ephemerides
% since they nav_msg is not always available
%-  Initialization Parameters
%
%--     Get ephemerides and iono information from navigation message
%navFile         = obtain_navFile(acq_info.nsGPSTime, acq_info.flags);
% let's guess that the nav RINEX is uncompressed correctly
%navFile = 'Rinex_v3/BCLN00ESP_R_20190440800_01H_GN.rnx';
%[eph, iono]     =   getNavRINEX(navFile);

%% Another option is to transform ephData into the matrix getNavRINEX returns

[eph, iono]     =   getEphMatrix(acq_info.SV, acq_info.flags)


%% Some initialitations

Nepoch       = 1;
%--     Number of unknowns of the PVT solution
Nsol        =   4;                  
%--     Number of iterations used to obtain the PVT solution
Nit         =   10;                   
%--     Reference position (check RINEX file or website of the station)
PVTr        =   acq_info.refLocation.XYZ;   %FIXME: add reference time
%--     Preliminary guess for PVT solution 
PVT0        =   acq_info.refLocation.XYZ;         % TODO: get preliminay guess, from obs header?
%--     Speed of light (for error calculations)
c           =   299792458;       %   Speed of light (m/s)
%--     Number of satellites for every epoch
Nsat        =   zeros(Nepoch, 1);
%--     Time corrections mean for every epoch
Tcorr        =   zeros(Nepoch, 1);
%--     Propagation corrections mean for every epoch
Pcorr        =   zeros(Nepoch, 1);

enab_corr    = 1;

%
PVT         =   nan(Nepoch,Nsol);       %   PVT solution
GDOP        =   zeros(Nepoch,1);        %   Gdop
PDOP        =   zeros(Nepoch,1);        %   Pdop
TOW         =   nan(Nepoch,1);          %   Time Of the Week (TOW)
G           =   cell(1, Nepoch);        %   Array of geometry matrixes as cells
pos_llh     =   nan(Nepoch, 3);         %   Position in Latitude, Longitude and Height


for epoch = 1:Nepoch    
    %--     Compute the PVT solution at the next epoch
    [PVT(epoch, :), A, Tcorr(epoch), Pcorr(epoch), X]  = ...
        PVT_recLS(acq_info, eph, iono, Nit, PVT0, enab_corr, acq_info.flags);
    
    G{epoch}          = inv(A'*A);      % Geometry matrix computation
    
    G_diag= diag(G{epoch});
    GDOP(epoch) = sqrt(sum(G_diag));
    PDOP(epoch) = sqrt(G_diag(1) + G_diag(2) + G_diag(3));
    
    
    pos_llh(epoch, :) = xyz2llh(PVT(epoch, :));     % Getting position in Latitude, Longitude, Height format
    pos_llh(epoch, 1) = rad2deg(pos_llh(epoch, 1));
    pos_llh(epoch, 2) = rad2deg(pos_llh(epoch, 2));
    
    %--     Update the initial guess for the next epoch
    PVT0 = PVT(epoch, :);
    %
end

%
%
%-  Show results

fprintf(' ==== RESULTS ==== \n')
Nmov            =   20;
ref_pos_llh     =   rad2deg(xyz2llh(PVTr));

pos_mean        =   nanmean(PVT(:,1:3),1);
posllh_mean     =   rad2deg(xyz2llh(pos_mean));
t_err           =   PVT(:,4)/c;
t_err_mean      =   mean(t_err);
mu_mov          =   movmean(PVT(:,1:3),[Nmov-1 0],1);
spread          =   nanstd(PVT(:,1:3), 0, 1);
p_err           =   sqrt((PVTr(1:3) - PVT(:, 1:3)).^2);
p_err_mean      =   sqrt((PVTr(1:3) - pos_mean).^2);
p_err_mean_llh  =   sqrt((ref_pos_llh - posllh_mean).^2);
p_err_mov       =   PVTr(1:3) - mu_mov;
rms             =   sqrt((PVTr(1) - PVT(:,1)).^2 + (PVTr(2) - PVT(:,2)).^2 + (PVTr(3) - PVT(:,3)).^2);
rms_mean        =   sqrt(sum((PVTr - pos_mean).^2));
% 
% -------------------------------------------------------------------------
fprintf('\nPosition computed using %s:', system);
fprintf('\n\nReferenc X: %f m  Y: %f m  Z: %f m', PVTr(1), PVTr(2), PVTr(3));
fprintf('\nComputed X: %f m  Y: %f m  Z: %f m\n ', pos_mean(1), pos_mean(2), pos_mean(3));
fprintf(strcat('\nLat.: %f', char(176),' Long.: %f', char(176), ' Height: %f m\n'), posllh_mean(1), posllh_mean(2), posllh_mean(3));
fprintf('\nEstimated time: %G s\n', PVT(4));
fprintf('\nTime error: %G s\n', t_err_mean);
fprintf('\nPosition error:');
fprintf('\nX: %f m Y: %f m Z:%f m', p_err_mean(1), p_err_mean(2), p_err_mean(3));
fprintf(strcat('\nLat: %f', char(176), ' Long: %f', char(176), ' Height: %f m \n\n'), p_err_mean_llh(1), p_err_mean_llh(2), p_err_mean_llh(3));

fprintf(strcat('2D error: %f m\n'), sqrt((p_err_mean(1))^2 + (p_err_mean(2))^2));
fprintf(strcat('3D error: %f m\n'), sqrt((p_err_mean(1))^2 + (p_err_mean(2))^2 + (p_err_mean(3))^2));

%fprintf('\nRMS in position as computed from mean position: %2.2f m \n', rms_mean);
%fprintf('\nstd (m) of each position coordinate:');
%fprintf('\nX: %2.2f Y: %2.2f Z:%2.2f\n', spread(1), spread(2), spread(3));
% -------------------------------------------------------------------------

%% Return parameters

latitude    = posllh_mean(1);
longitude   = posllh_mean(2);
end