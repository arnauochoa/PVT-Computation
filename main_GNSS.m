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

%% Hardcoded for testing (in order not to modify the files directly)
acq_info.flags.constellations.GPS           =   1;
acq_info.flags.constellations.Galileo       =   0;
acq_info.flags.corrections.ionosphere       =   0;
acq_info.flags.corrections.troposphere      =   0;
acq_info.flags.corrections.f2corr           =   0;
acq_info.flags.algorithm.LS                 =   0;
acq_info.flags.algorithm.WLS                =   0;

if acq_info.flags.constellations.GPS
    system  =   'GPS';
end

if acq_info.flags.constellations.Galileo
    system   =   'Galileo';
end

if acq_info.flags.constellations.GPS && acq_info.flags.constellations.Galileo
    system   =   'GPS + Galileo';
end

%% Masks application
maskType = 1; % 1 = elevation, 2 = CN0
maskValue = 0;

if maskType ~= 0
    acq_info = apply_mask(acq_info, maskType, maskValue);
end

%% It is needed to download a navigation message to obtain ephemerides
% since they nav_msg is not always available
%-  Initialization Parameters
%
%--     Get ephemerides and iono information from navigation message
% navFile         = obtain_navFile(acq_info.nsGPSTime, acq_info.flags);
% [eph, acq_info.ionoProto]     =   getNavRINEX(navFile);

%% Another option is to transform ephData into the matrix getNavRINEX return
eph     =   getEphMatrix(acq_info.SV, acq_info.flags);

%% Some initializations
PVT0        =   acq_info.refLocation.XYZ;  % Preliminary guess for PVT solution     
c           =   299792458;       %   Speed of light (m/s)
 
%% Compute the PVT solution
PVT  = PVT_recLS_multiC(acq_info, eph);

pos_llh = xyz2llh(PVT);     % Getting position in Latitude, Longitude, Height format
pos_llh(1) = rad2deg(pos_llh(1));
pos_llh(2) = rad2deg(pos_llh(2));

%% Return parameters
latitude    = pos_llh(1);
longitude   = pos_llh(2);

%% Results
fprintf(' ==== RESULTS ==== \n')
Nmov            =   20;
ref_pos_llh     =   rad2deg(xyz2llh(PVT0));
LLH0            =   xyz2llh(PVT0);
LLH0            =   [rad2deg(LLH0(1:2)) LLH0(3)];
LLH             =   xyz2llh(PVT);
LLH             =   [rad2deg(LLH(1:2)) LLH(3)];

t_err           =   acq_info.TOW - PVT(4);
p_err           =   sqrt((PVT0(1:3) - PVT(:, 1:3)).^2);
p_err_llh       =   sqrt((LLH0 - LLH).^2);
%rms             =   sqrt((PVT0(1) - PVT(:,1)).^2 + (PVT0(2) - PVT(:,2)).^2 + (PVT0(3) - PVT(:,3)).^2);
%rms_mean        =   sqrt(sum((PVT0 - pos_mean).^2));
%llhref          =   xyz2llh(PVT0);
% 
% -------------------------------------------------------------------------
fprintf('\nPosition computed using %s:', system);
fprintf('\n\nReferenc X: %f m  Y: %f m  Z: %f m', PVT0(1), PVT0(2), PVT0(3));
fprintf('\nComputed X: %f m  Y: %f m  Z: %f m\n\n', PVT(1), PVT(2), PVT(3));
fprintf(strcat('Referenc Lat.: %f', char(176),' Long.: %f', char(176), ' Height: %f m\n'), LLH0(1), LLH0(2), LLH0(3));
fprintf(strcat('Computed Lat.: %f', char(176),' Long.: %f', char(176), ' Height: %f m\n'), LLH(1), LLH(2), LLH(3));
fprintf('\nReal time: %G s', acq_info.TOW);
fprintf('\nEstimated time: %G s\n', PVT(4));
fprintf('\nTime error: %G s\n', t_err);
fprintf('\nPosition error:');
fprintf('\nX: %f m Y: %f m Z: %f m', p_err(1), p_err(2), p_err(3));
fprintf(strcat('\nLat: %f', char(176), ' Long: %f', char(176), ' Height: %f m \n\n'), p_err_llh(1), p_err_llh(2), p_err_llh(3));

fprintf(strcat('2D error: %f m\n'), sqrt((p_err(1))^2 + (p_err(2))^2));
fprintf(strcat('3D error: %f m\n'), sqrt((p_err(1))^2 + (p_err(2))^2 + (p_err(3))^2));
end

%% Test code
% Elevation mask
%elevMask = 0; % degrees
% if 1 % elevation mask flag
%     tmp         =   [];
%     if acq_info.flags.constellations.GPS
%         for i=1:length(acq_info.SV.GPS)
%             if acq_info.SV.GPS(i).Elevation < elevMask
%                 tmp                     =   [tmp i]; 
%             end
%         end
%         tmp     = 	sort(tmp, 'descend');
%         for i=1:length(tmp)
%             acq_info.SV.GPS(tmp(i))   	=   [];
%         end
%     end
%     
%     tmp     =   [];
%     if acq_info.flags.constellations.Galileo
%         for i=1:length(acq_info.SV.Galileo)
%             if acq_info.SV.Galileo(i).Elevation < elevMask
%                 tmp                     =   [tmp i];
%             end        
%         end
%         tmp     = 	sort(tmp, 'descend');
%         for i=1:length(tmp)
%             acq_info.SV.Galileo(tmp(i))	=   [];
%         end
%     end
% end

% CN0 mask
%cn0Mask = 0; %dBHz

%if 1 % CN0 mask flag
%     tmp         =   [];
%     if acq_info.flags.constellations.GPS
%         for i=1:length(acq_info.SV.GPS)
%             if acq_info.SV.GPS(i).CN0 < cn0Mask
%                 tmp                     =   [tmp i]; 
%             end
%         end
%         tmp     = 	sort(tmp, 'descend');
%         for i=1:length(tmp)
%             acq_info.SV.GPS(tmp(i))   	=   [];
%         end
%     end
%     
%     tmp     =   [];
%     if acq_info.flags.constellations.Galileo
%         for i=1:length(acq_info.SV.Galileo)
%             if acq_info.SV.Galileo(i).CN0 < cn0Mask
%                 tmp                     =   [tmp i];
%             end        
%         end
%         tmp     = 	sort(tmp, 'descend');
%         for i=1:length(tmp)
%             acq_info.SV.Galileo(tmp(i))	=   [];
%         end
%     end
%end