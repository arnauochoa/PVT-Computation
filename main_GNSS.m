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

%% Transform ephData into the matrix getNavRINEX returns
[eph, iono]     =   getEphMatrix(acq_info.SV, acq_info.flags);


%% Some initialitations      
%--     Number of iterations used to obtain the PVT solution
Nit         =   10;                   
%--     Preliminary guess for PVT solution 
PVT0        =   acq_info.refLocation.XYZ;         % TODO: get preliminay guess, from obs header?
%--     Speed of light (for error calculations)
c           =   299792458;       %   Speed of light (m/s)

enab_corr    = 1;

%--     Compute the PVT solution at the next epoch
PVT     =  PVT_recLS(acq_info, eph, iono, Nit, PVT0, enab_corr, acq_info.flags);

pos_llh = xyz2llh(PVT);     % Getting position in Latitude, Longitude, Height format
pos_llh(1) = rad2deg(pos_llh(1));
pos_llh(2) = rad2deg(pos_llh(2));

%% Return parameters

latitude    = pos_llh(1);
longitude   = pos_llh(2);

%
%% IMPORTANT!!! DO NOT ADD THIS TO C++
%-  Show results
%--     Reference position (check RINEX file or website of the station)
PVTr        =   acq_info.refLocation.XYZ;   %FIXME: add reference time

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
end