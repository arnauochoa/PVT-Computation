function [av_results, H, test] = main_GNSS(json_content)

%
addpath 'Corrections';
addpath 'Corrections/Control_segment';
addpath 'Corrections/Prop_Effects';
addpath 'Ephemeris';
addpath 'Misc';
addpath 'Observations';
addpath 'JSON';
    
boolprint = 0;

%% Build struct from JSON
GNSS_info       = jsondecode(json_content);

%% Averaging loop 
for i=1:length(GNSS_info)
    
    %% Executions with different configurations
    for j=1:length(GNSS_info(i).Params)
        %% Create acquisition struct from GNSS_info
        acq_info        =   extract_info(GNSS_info(i), j);

        %% Some initializations
        PVT0        =   acq_info.refLocation.XYZ;  % Preliminary guess for PVT solution     
        c           =   299792458;       %   Speed of light (m/s)

        %% Hardcoded for testing (in order not to modify the files directly)
%         acq_info.flags.constellations.GPS           =   1;
%         acq_info.flags.constellations.Galileo       =   1;
%         acq_info.flags.corrections.ionosphere       =   0;
%         acq_info.flags.corrections.troposphere      =   0;
         acq_info.flags.corrections.f2corr           =   0;
%         acq_info.flags.algorithm.LS                 =   0;
%         acq_info.flags.algorithm.WLS                =   0;

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
        maskType = 0; % 1 = elevation, 2 = CN0
        maskValue = 20; % degrees or dBHz

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

        %% Compute the PVT solution
        % XYZ
        [PVT, H]             =   PVT_recLS_multiC(acq_info, eph);
        PVTs(i, j, :) 	=	PVT;
        
        % LLH
        result              =   [xyz2llh(PVT(i, 1:3)) PVT(i, 4)];
        result              =   [rad2deg(result(i, 1:2)) result(i, 3) result(i, 4)];       
        results(i, j, :)    =   result;

        if boolprint
            fprintf('\nResults GNSS %G Params %G\n%f, %f\n', i, j, results(i, j, 1), results(i, j, 2));
        end
    
    end 

end

%% Averaging
for i=1:size(results, 2)
    for j=1:size(results, 3)
        av_results(i, j)    =   (1/size(results, 1))*sum(results(:, i, j));
    end
end

for i=1:size(PVTs, 2)
    for j=1:size(PVTs, 3)
        av_PVTs(i, j)       =   (1/size(PVTs, 1))*sum(PVTs(:, i, j));
    end
end

%% Return parameters
latitudes       =   av_results(:, 1);
longitudes      =  	av_results(:, 2);
heights         =   av_results(:, 3);
times           =   av_results(:, 4);
av_PVT          =   [latitudes(1) longitudes(1) heights(1)];
time            =   times(1);
test            =   [PVT0 acq_info.TOW];

    if boolprint
        %% Results
        fprintf(' ==== RESULTS ==== \n')
        LLH0            =   xyz2llh(PVT0);
        LLH0            =   [rad2deg(LLH0(1:2)) LLH0(3)];
        %LLH             =   xyz2llh(av_results);
        %LLH             =   [rad2deg(LLH(1:2)) LLH(3)];

        %t_err           =   acq_info.TOW - av_results(4) - 2.5 ; % -2.5 because 5 gathers*0.5s/gather = 2.5s
        t_err           =   acq_info.TOW - time; % -2.5 because 5 gathers*0.5s/gather = 2.5s
        av_results_XYZ  =   lla2ecef(av_PVT);
        p_err           =   sqrt((PVT0(1:3) - av_results_XYZ).^2);
        p_err_llh       =   sqrt((LLH0 - av_results(1:3)).^2);
        %rms             =   sqrt((PVT0(1) - PVT(:,1)).^2 + (PVT0(2) - PVT(:,2)).^2 + (PVT0(3) - PVT(:,3)).^2);
        %rms_mean        =   sqrt(sum((PVT0 - pos_mean).^2));
        %llhref          =   xyz2llh(PVT0);
        % 
        % -------------------------------------------------------------------------
        fprintf('\nPosition computed using %s:', system);
        fprintf('\n\nReferenc X: %f m  Y: %f m  Z: %f m\n', PVT0(1), PVT0(2), PVT0(3));
        fprintf('Computed X: %f m  Y: %f m  Z: %f m\n\n', lla2ecef(av_PVT));
        fprintf(strcat('Referenc Lat.: %f', char(176),' Long.: %f', char(176), ' Height: %f m\n'), LLH0(1), LLH0(2), LLH0(3));
        fprintf(strcat('Computed Lat.: %f', char(176),' Long.: %f', char(176), ' Height: %f m\n'), av_PVT(1), av_PVT(2), av_PVT(3));
        fprintf('\nReal time: %f s', acq_info.TOW);
        fprintf('\nEstimated time: %f s\n', time);
        fprintf('\nTime error: %G s\n', t_err);
        fprintf('\nPosition error:');
        fprintf('\nX: %f m Y: %f m Z: %f m', p_err(1), p_err(2), p_err(3));
        fprintf(strcat('\nLat: %f', char(176), ' Long: %f', char(176), ' Height: %f m \n\n'), p_err_llh(1), p_err_llh(2), p_err_llh(3));

        fprintf(strcat('2D error: %f m\n'), sqrt((p_err(1))^2 + (p_err(2))^2));
        fprintf(strcat('3D error: %f m\n'), sqrt((p_err(1))^2 + (p_err(2))^2 + (p_err(3))^2));
    end
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