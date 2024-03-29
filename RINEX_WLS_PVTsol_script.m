% Analyze RINEX files in order to compute the PVT solution
% Single constellation using WLS
%
clearvars;
close all;
clc;
fclose('all');
%
addpath 'Corrections';
addpath 'Corrections/Control_segment';
addpath 'Corrections/Prop_Effects';
addpath 'Ephemeris';
addpath 'Misc';
addpath 'Observations';

%-  Setting Parameters
%--     CONSTELLATION
%---        Satellite constellation to be used for the PVT computation
const       =   'GPS';  % GPS/GAL/GLO
%--     SMOOTHING
%---        Smoothing window (number of epochs)
window      =   10;
%--     CORRECTIONS
%---        Enable/disable corrections
enab_corr   =   true;
%--     MASKING
%---        Threshold angle defined in deg
thres_deg   =   0;
%---        Threshold angle defined in rad
threshold   =   deg2rad(thres_deg);
%--     EPOCHS
%---        Number of epochs to be analyzed (max. 2880)
Nepoch      =   200;
%--     FILES
%---        Navigation RINEX file
if strcmp(const, 'GPS'), NavFile = 'RINEX/BCLN00ESP_R_20182870000_01D_GN.rnx'; end
if strcmp(const, 'GAL'), NavFile = 'RINEX/BCLN00ESP_R_20182870000_01D_EN.rnx'; end
%---        Observation RINEX file
ObsFile     =   'RINEX/BCLN00ESP_R_20182870000_01D_30S_MO.rnx';  

%-  Initialization Parameters
%--     Number of unknowns of the PVT solution
Nsol        =   4;                  
%--     Number of iterations used to obtain the PVT solution
Nit         =   20;                   
%--     Reference position (check RINEX file or website of the station)
PVTr        =   [4788065.1430, 167551.1700, 4196354.9920];   %FIXME: add reference time
%--     Preliminary guess for PVT solution 
PVT0        =   [0 0 0 0];         % TODO: get preliminay guess, from obs header?
%--     Speed of light (for error calculations)
c           =   299792458;       %   Speed of light (m/s)
%--     Number of satellites for every epoch
Nsat        =   zeros(Nepoch, 1);
%--     Time corrections mean for every epoch
Tcorr        =   zeros(Nepoch, 1);
%--     Propagation corrections mean for every epoch
Pcorr        =   zeros(Nepoch, 1);

%--     Get ephemerides and iono information from navigation message
[eph, iono] =  getNavRINEX(NavFile);

%--     Open Observation RINEX file and take the header information
%   Nobs:       # of observables (integer), check RINEX version
%   Obs_types:  List of observation types (string), check RINEX version
%   Rin_vers:   RINEX version (integer: 2 or 3)
fid         = fopen(ObsFile);
[Nobs, Obs_types, year, Rin_vers]  =   anheader(fid);
%
PVT         =   nan(Nepoch,Nsol);       %   PVT solution
PVTs        =   nan(Nepoch,Nsol);       %   Smoothed PVT solution
GDOP        =   zeros(Nepoch,1);        %   Gdop
PDOP        =   zeros(Nepoch,1);        %   Pdop
TOW         =   nan(Nepoch,1);          %   Time Of the Week (TOW)
G           =   cell(1, Nepoch);        %   Array of geometry matrixes as cells
pos_llh     =   nan(Nepoch, 3);         %   Position in Latitude, Longitude and Height
mask_sats   =   zeros(Nepoch, 1);       %   Number masked satellites for every epoch
sats_el     =   cell(Nepoch, 1);        %   Satellites elevations for every epoch


%-  Sequentially read the Observation file and compute the PVT solution
for epoch = 1:Nepoch
    %--     Get the observed pseudoranges for all satellites in view of 
    %       a given constellation at the next epoch
    %
    %   pr:     Pseudoranges at given TOW for satellites in sats
    %           (Nsatx1)
    %   TOW:    Time Of the Week (TOW) of the next epoch    
    %   sats:   Satellites in view  
    %
    %--  
    [pr, TOW(epoch), sats] = getPR_epoch0(fid, year, Obs_types, Nobs, Rin_vers, const);
    Nsat(epoch) = length(sats);
    
    if epoch == 1
        %--     Compute the PVT solution at the next epoch
        [PVT(epoch, :), A, Tcorr(epoch), Pcorr(epoch), X]  = ...
            PVT_recLS(pr, sats, TOW(epoch), eph, iono, Nit, PVT0, enab_corr);
    else
        %--     Compute the PVT solution at the next epoch
        [PVT(epoch, :), A, Tcorr(epoch), Pcorr(epoch), X, mask_sats(epoch), sats_el{epoch}]  = ...
            PVT_recWLS(pr, sats, TOW(epoch), eph, iono, Nit, PVT0, enab_corr, threshold);
    end
    
    if epoch < window       % If there are NOT enough epochs
        PVTs(epoch, :) = mean(PVT(1 : epoch, :), 1);
    else                    % If there are enough epochs
        PVTs(epoch, :) = mean(PVT((epoch - window + 1) : epoch, :), 1);
    end
    
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
Nmov            =   100;

%-- Normal PVT
pos_mean        =   nanmean(PVT(:,1:3),1);
posllh_mean     =   rad2deg(xyz2llh(pos_mean));
t_err           =   PVT(:,4)/c;
t_err_mean      =   mean(t_err);
% mu_mov          =   movmean(PVT(:,1:3),[Nmov-1 0],1);
spread          =   nanstd(PVT(:,1:3), 0, 1);
p_err           =   sqrt((PVTr(1:3) - PVT(:, 1:3)).^2);
% p_err_mov       =   PVTr(1:3) - mu_mov;
rms             =   ((PVTr(1) - PVT(:,1)).^2 + (PVTr(2) - PVT(:,2)).^2 + (PVTr(3) - PVT(:,3)).^2).^0.5;

%-- Smoothed PVT
% sm_pos_mean     =   nanmean(PVTs(:,1:3),1);
% sm_posllh_mean  =   rad2deg(xyz2llh(sm_pos_mean));
sm_t_err        =   PVTs(:,4)/c;
sm_t_err_mean   =   mean(sm_t_err);
sm_spread       =   nanstd(PVTs(:,1:3), 0, 1);
sm_p_err        =   sqrt((PVTr(1:3) - PVTs(:, 1:3)).^2);
sm_rms          =   ((PVTr(1) - PVTs(:,1)).^2 + (PVTr(2) - PVTs(:,2)).^2 + (PVTr(3) - PVTs(:,3)).^2).^0.5;

% 
% -------------------------------------------------------------------------
fprintf('\nMean position as computed from %2.0f epochs:', Nepoch);
fprintf('\n\nX: %12.3f  Y: %12.3f  Z: %12.3f\n', pos_mean(1), pos_mean(2), pos_mean(3));
fprintf('\nLat.: %12.3fº   Long.: %12.3fº   Height: %12.3f m\n', posllh_mean(1), posllh_mean(2), posllh_mean(3));
fprintf('\nMean time error as computed from %2.0f epochs: %G seconds\n', Nepoch, t_err_mean);
fprintf('\nstd (m) of each position coordinate:');
fprintf('\nX: %2.2f Y: %2.2f Z:%2.2f\n', spread(1), spread(2), spread(3));

if Nepoch==1    % Print error position when there's only one epoch
    fprintf('\nError in position as computed from 1 epoch:');
    fprintf('\nX: %2.2f m Y: %2.2f m Z:%2.2f m \n', p_err(1), p_err(2), p_err(3));
end
% -------------------------------------------------------------------------



% ----------------------------- PLOTS -------------------------------------
% Re      =   6371000; % m
% [x,y,z] =   sphere(100);
% fig = figure('DefaultAxesFontSize', 12);
% plot3(X(1, :), X(2, :), X(3, :), 'rx');
% hold on;    plot3(PVT(Nepoch,1), PVT(Nepoch,1), PVT(Nepoch,1), 'bx');
% hold on;    surf(x*Re, y*Re, z*Re);
% rotate3d on;
% title('Satellites position and PVT from last epoch');

linewidth = 1;

if Nepoch > 1   % Plots for various epochs
    fig = figure('DefaultAxesFontSize', 12);
    plot(TOW, thres_deg*ones(Nepoch, 1), 'LineWidth', linewidth); hold on;
    plot(TOW, zeros(Nepoch, 1), 'LineWidth', linewidth); hold on;
    for epoch=1:Nepoch
        a = TOW(epoch)*ones(length(sats_el{epoch}), 1);
        b = rad2deg(sats_el{epoch});
        plot(a, b, 'r.', 'DisplayName','Satellites'); hold on;
    end
    hold off;
    xlabel('Time of the Week (s)');
    ylabel('Elevation angle (°)');
    title(sprintf('Elevation angles (%s)', const));
%     filename = sprintf('Capt/WLS/%s/elev_%u_%u_c%u.jpg', const, Nepoch, thres_deg, enab_corr);
%     saveas(fig, filename);
    
    % -- Errors (RMS) in X-Y-Z
    fig = figure('DefaultAxesFontSize', 12); plot(TOW, p_err, 'LineWidth', linewidth);
    legend('X error', 'Y error', 'Z error');
    xlabel('Time of the Week (s)');
    ylabel('Error for each coordinate (m)');
    title(sprintf('Evolution of the errors in the different axes (%s, alpha = %u°)\n', const, thres_deg));
%     filename = sprintf('Capt/WLS/%s/err_XYZ_%u_%u_c%u.jpg', const, Nepoch, thres_deg, enab_corr);
%     saveas(fig, filename);
    %
    % -- Errors (RMS) in X-Y-Z SMOOTHED
    fig = figure('DefaultAxesFontSize', 12); plot(TOW, sm_p_err, 'LineWidth', linewidth);
    legend('X error', 'Y error', 'Z error');
    xlabel('Time of the Week (s)');
    ylabel('Error for each coordinate (m)');
    title(sprintf('Evolution of the smoothed errors in the different axes \n(%s, alpha = %u°, window = %u)', const, thres_deg, window));
%     filename = sprintf('Capt/WLS/%s/sm%u_err_XYZ_%u_%u_c%u.jpg', const, window, Nepoch, thres_deg, enab_corr);
%     saveas(fig, filename);
    %
    % -- RMS evolution 
    fig = figure('DefaultAxesFontSize', 12); plot(TOW, rms, 'LineWidth', linewidth);
    xlabel('Time of the Week (s)');
    ylabel('Root Mean Square error (m)');
    title(sprintf('RMS evolution (%s, alpha = %u°)\n', const, thres_deg));
%     filename = sprintf('Capt/WLS/%s/rms_%u_%u_c%u.jpg', const, Nepoch, thres_deg, enab_corr);
%     saveas(fig, filename);
    %
    % -- RMS evolution SMOOTHED
    fig = figure('DefaultAxesFontSize', 12); plot(TOW, sm_rms, 'LineWidth', linewidth);
    xlabel('Time of the Week (s)');
    ylabel('Root Mean Square error (m)');
    title(sprintf('Smoothed RMS evolution \n(%s, alpha = %u°, window = %u)', const, thres_deg, window));
%     filename = sprintf('Capt/WLS/%s/sm%u_rms_%u_%u_c%u.jpg', const, window, Nepoch, thres_deg, enab_corr);
%     saveas(fig, filename);
    %
    % -- Error in time
    fig = figure('DefaultAxesFontSize', 12); plot(TOW, t_err, 'LineWidth', linewidth);
    xlabel('Time of the Week (s)');
    ylabel('Error in time (s)');
    title(sprintf('Evolution of the bias in time (%s, alpha = %u°)\n', const, thres_deg));
%     filename = sprintf('Capt/WLS/%s/tbias_%u_%u_c%u.jpg', const, Nepoch, thres_deg, enab_corr);
%     saveas(fig, filename);
    %
    % -- Error in time SMOOTHED
    fig = figure('DefaultAxesFontSize', 12); plot(TOW, sm_t_err, 'LineWidth', linewidth);
    xlabel('Time of the Week (s)');
    ylabel('Error in time (s)');
    title(sprintf('Evolution of the smoothed bias in time \n(%s, alpha = %u°, window = %u)\n', const, thres_deg, window));
%     filename = sprintf('Capt/WLS/%s/sm%u_tbias_%u_%u_c%u.jpg', const, window, Nepoch, thres_deg, enab_corr);
%     saveas(fig, filename);
    %
    % -- # satellites in view
    fig = figure('DefaultAxesFontSize', 12); plot(TOW, Nsat, 'LineWidth', linewidth);
    hold on; plot(TOW, Nsat - mask_sats, 'LineWidth', linewidth);
    legend('In view', 'Used');
    ylabel('Number of satellites');
    xlabel('Time of the Week (s)');
    title(sprintf('Evolution of number of satellites (%s, alpha = %u°)\n', const, thres_deg));
%     filename = sprintf('Capt/WLS/%s/nsat_%u_%u_c%u.jpg', const, Nepoch, thres_deg, enab_corr);
%     saveas(fig, filename);
    %
    % -- RMS evolution & # sal¡tellites
    fig = figure('DefaultAxesFontSize', 12);
    yyaxis left;
    plot(TOW, rms, 'LineWidth', linewidth);
    ylabel('Root Mean Square error (m)');
    yyaxis right;
    plot(TOW, Nsat - mask_sats, 'LineWidth', linewidth);
    ylabel('Satellites used');
    xlabel('Time of the Week (s)');
    title(sprintf('RMS evolution (%s, alpha = %u°)\n', const, thres_deg));
%     filename = sprintf('Capt/WLS/%s/rms-nsat_%u_%u_c%u.jpg', const, Nepoch, thres_deg, enab_corr);
%     saveas(fig, filename);
    %
    % -- GDOP evolution & # sal¡tellites
    fig = figure('DefaultAxesFontSize', 12); 
    yyaxis left;
    plot(TOW, GDOP, 'LineWidth', linewidth);
    ylabel('GDOP');
    yyaxis right;
    plot(TOW, Nsat - mask_sats, 'LineWidth', linewidth);
    ylabel('Satellites used');
    xlabel('Time of the Week (s)');
    title(sprintf('GDOP evolution (%s, alpha = %u°)\n', const, thres_deg));
%     filename = sprintf('Capt/WLS/%s/gdop-nsat_%u_%u_c%u.jpg', const, Nepoch, thres_deg, enab_corr);
%     saveas(fig, filename);
    %
    % -- PDOP evolution & # sal¡tellites
    fig = figure('DefaultAxesFontSize', 12); 
    yyaxis left;
    plot(TOW, PDOP, 'LineWidth', linewidth);
    ylabel('PDOP');
    yyaxis right;
    plot(TOW, Nsat - mask_sats, 'LineWidth', linewidth);
    ylabel('Satellites used');
    xlabel('Time of the Week (s)');
    title(sprintf('PDOP evolution (%s, alpha = %u°)\n', const, thres_deg));
%     filename = sprintf('Capt/WLS/%s/pdop-nsat_%u_%u_c%u.jpg', const, Nepoch, thres_deg, enab_corr);
%     saveas(fig, filename);
    %
    % -- Time & Propagation corrections evolution
    fig = figure('DefaultAxesFontSize', 12);
    yyaxis left;
    plot(TOW, Tcorr, 'LineWidth', linewidth);
    ylabel('Time corrections (s)');
    yyaxis right;
    plot(TOW, Pcorr, 'LineWidth', linewidth);
    ylabel('Propagation corrections (m)');
    xlabel('Time of the Week (s)');
    title(sprintf('Time & Propagation corrections evolution (%s, alpha = %u°)\n', const, thres_deg));
%     filename = sprintf('Capt/WLS/%s/terr-perr_%u_%u_c%u.jpg', const, Nepoch, thres_deg, enab_corr);
%     saveas(fig, filename);
end
