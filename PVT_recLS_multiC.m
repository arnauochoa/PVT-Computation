function    [PVT, H]  =   PVT_recLS_multiC(acq_info, eph)
% PVT_recLS:    Computation of the receiver position at time TOW from  
%               pseudoranges (pr) and ephemerides information (eph). 
%               Implementation using the iterative Least-Squares principle 
%               after linearization of the navigation equations. We use the
%               svn Id (svn) to get the satellite coordinates corresponding 
%               to the pseudoranges given by the input (pr).
%               
% Input:            
%               acq_info:   Struct with all the acquisition information
%                           extracted from the phone.
%               eph:        Struct with all the matrix ephemeris 
%                           information for different constellations
%
% Output:       PVT:        Nsolx1 vector with the estimated PVT solution                  
%
        
    %% General initializations
    c           =   299792458; 
    Nit         =   5; 
    emptysat    =   [];
    
    %% LS loop
    for iter = 1:Nit
        % Declarations
        if (iter == 1)
            PVT     =   [acq_info.refLocation.XYZ acq_info.TOW];
            iono    =   acq_info.ionoProto;
        end
        
        %% GPS loop
        if acq_info.flags.constellations.GPS
            
            if (iter == 1)
                nGPS            =   length(acq_info.SV.GPS);
                GPS_A           =   zeros(nGPS, 3);
                GPS_p           =   zeros(nGPS, 1);
                GPS_tcorr       =   zeros(nGPS, 1);
                GPS_Pcorr       =   zeros(nGPS, 1);
                GPS_X           =   zeros(3, nGPS);
                GPS_pr          =   [];
                GPS_svn         =   [];
                GPS_CN0         =   [];
                for i=1:nGPS
                    GPS_pr      =   [GPS_pr acq_info.SV.GPS(i).p];
                    GPS_svn     =   [GPS_svn acq_info.SV.GPS(i).svid];
                    GPS_CN0     =   [GPS_CN0 acq_info.SV.GPS(i).CN0];
                end    
                GPS_svn         =   (unique(GPS_svn', 'rows'))';
                GPS_pr          =   GPS_pr(1:length(GPS_svn));
                GPS_CN0         =   GPS_CN0(1:length(GPS_svn));
                nGPS            =   length(GPS_svn);
            end
        
            for sat = 1:nGPS                
                %% GPS corrections
                % GPS satellite coordinates and time correction (always applying)
                if (iter == 1)
                    [GPS_X(:, sat), GPS_tcorr(sat)]  =   getCtrl_corr(eph.GPS, GPS_svn(sat), PVT(4), GPS_pr(sat));
                end
                GPS_corr                =   c * GPS_tcorr(sat);
                
                % Another GPS corrections (depending on flags)
                
                % Ionosphere and troposphere corrections
                if acq_info.flags.corrections.ionosphere || acq_info.flags.corrections.troposphere
                    [GPS_tropoCorr, GPS_ionoCorr]           =   getProp_corr(GPS_X(:, sat), PVT, iono, PVT(4));  % Iono + Tropo correction
                    if acq_info.flags.corrections.troposphere 
                        GPS_corr            =   GPS_corr + GPS_tropoCorr; % troposphere correction
                    end
                    if acq_info.flags.corrections.ionosphere
                        GPS_corr            =   GPS_corr + GPS_ionoCorr; % ionosphere correction
                    end
                end
                
                % Ionosphere correction based on dual frequency
                if iter == 1
                    if acq_info.flags.corrections.f2corr
                     	[GPS_prcorr2f GPS_phcorr2f GPS_idx]   =   getIonoCorrDualFreq(acq_info.SV.GPS);

                        for i=1:length(GPS_idx)
                            GPS_pr(GPS_idx(i))   =   GPS_pr(GPS_idx(i)) + GPS_prcorr2f(i); 
                        end
                    end
                end
                            
                % Corrections application
                GPS_pr_c                =   GPS_pr(sat) + GPS_corr;   %   Corrected pseudorange
                
                %% GPS geometric matrix generation
                if (~isnan(GPS_pr_c))    % Fill as long as there is C1 measurement,
                                     % otherwise discard the measurement.
                    %--     Fill the measurement vector (rhoc_i - d0_i)
                    GPS_d0  = sqrt((GPS_X(1,sat) - PVT(1))^2 + (GPS_X(2,sat) - PVT(2))^2 + (GPS_X(3,sat) - PVT(3))^2); %TODO: shorten
                    GPS_p(sat)          =   GPS_pr_c - GPS_d0;
                    %
                    %--     Fill the geometry matrix (TBD)
                    GPS_ax              =   -(GPS_X(1, sat) - PVT(1)) / GPS_d0;   % dx/d0
                    GPS_ay              =   -(GPS_X(2, sat) - PVT(2)) / GPS_d0;   % dy/d0
                    GPS_az              =   -(GPS_X(3, sat) - PVT(3)) / GPS_d0;   % dz/d0
                    GPS_A(sat, 1:3)     =   [GPS_ax GPS_ay GPS_az];
                    % 
                end       
            end
            % Delete rows of 0s
            if iter == 1
                for i=1:length(GPS_A)
                    if GPS_A(i,:) == 0
                        emptysat = [emptysat i];
                    end
                end
                emptysat = emptysat(length(emptysat):-1:1);
                for i=1:length(emptysat)
                   GPS_A(emptysat(i),:) = [];
                   GPS_p(emptysat(i))   = [];
                end
            end
            emptysat         = []; 
        else
            GPS_A       =   [];
            GPS_p       =   [];
            GPS_CN0     =   [];
            GPS_tcorr   =   [];
            GPS_Pcorr   =   [];
        end

        %% Galileo loop
        if acq_info.flags.constellations.Galileo
            
            if (iter == 1)
                nGalileo    = length(acq_info.SV.Galileo);
                Galileo_A       =   zeros(nGalileo, 3);
                Galileo_p       =   zeros(nGalileo, 1);
                %tcorr       =   zeros(nGalileo, 1);
                %Pcorr       =   zeros(nGalileo, 1);
                %X           =   zeros(3, nGalileo);
                Galileo_pr          = [];
                Galileo_svn         = [];
                Galileo_CN0         = [];
                for i=1:nGalileo
                    Galileo_pr      =   [Galileo_pr acq_info.SV.Galileo(i).p];
                    Galileo_svn     =   [Galileo_svn acq_info.SV.Galileo(i).svid];
                    Galileo_CN0     =   [Galileo_CN0 acq_info.SV.Galileo(i).CN0];
                end
                Galileo_svn         =   (unique(Galileo_svn', 'rows'))';
                Galileo_pr          =   Galileo_pr(1:length(Galileo_svn));
                Galileo_CN0         =   Galileo_CN0(1:length(Galileo_svn));
                nGalileo            =   length(Galileo_svn);
            end
            
            for sat = 1:nGalileo
                %% Galileo corrections
                % Galileo satellite coordinates and time correction (always applying)
                if (iter == 1)  % Only 1st iteration
                    [Galileo_X(:, sat), Galileo_tcorr(sat)]  =   getCtrl_corr(eph.Galileo, Galileo_svn(sat), PVT(4), Galileo_pr(sat));
                end
                Galileo_corr                =   c * Galileo_tcorr(sat);
                
                % Another Galileo corrections (depending on flags)
                
                % Ionosphere and troposphere corrections
                if acq_info.flags.corrections.ionosphere || acq_info.flags.corrections.troposphere
                    [Galileo_tropoCorr, Galileo_ionoCorr]           =   getProp_corr(Galileo_X(:, sat), PVT, iono, PVT(4));  % Iono + Tropo correction
                    if acq_info.flags.corrections.troposphere 
                        Galileo_corr            =   Galileo_corr + Galileo_tropoCorr; % troposphere correction
                    end
                    if acq_info.flags.corrections.ionosphere
                        Galileo_corr            =   Galileo_corr + Galileo_ionoCorr; % ionosphere correction
                    end
                end
                
                % Ionosphere correction based on dual frequency
                if iter == 1
                    if acq_info.flags.corrections.f2corr
                     	[Galileo_prcorr2f Galileo_phcorr2f Galileo_idx]   =   getIonoCorrDualFreq(acq_info.SV.Galileo);

                        for i=1:length(Galileo_idx)
                            Galileo_pr(Galileo_idx(i))   =   Galileo_pr(Galileo_idx(i)) + Galileo_prcorr2f(i); 
                        end
                    end
                end
                
                % Corrections application
                Galileo_pr_c                =   Galileo_pr(sat) + Galileo_corr;   %   Corrected pseudorange
                
                %% Galileo geometric matrix generation
                if (~isnan(Galileo_pr_c))    % Fill as long as there is C1 measurement,
                                     % otherwise discard the measurement.
                    %--     Fill the measurement vector (rhoc_i - d0_i)
                    Galileo_d0              = sqrt((Galileo_X(1,sat) - PVT(1))^2 + (Galileo_X(2,sat) - PVT(2))^2 + (Galileo_X(3,sat) - PVT(3))^2); %TODO: shorten
                    Galileo_p(sat)          =   Galileo_pr_c - Galileo_d0;
                    %
                    %--     Fill the geometry matrix
                    Galileo_ax              =   -(Galileo_X(1, sat) - PVT(1)) / Galileo_d0;   % dx/d0
                    Galileo_ay              =   -(Galileo_X(2, sat) - PVT(2)) / Galileo_d0;   % dy/d0
                    Galileo_az              =   -(Galileo_X(3, sat) - PVT(3)) / Galileo_d0;   % dz/d0
                    Galileo_A(sat, 1:3)     =   [Galileo_ax Galileo_ay Galileo_az];
                    % 
                end
            end
            % Delete rows of 0s
            if iter == 1
                for i=1:length(Galileo_A)
                    if Galileo_A(i,:) == 0
                        emptysat = [emptysat i];
                    end
                end
                emptysat = emptysat(length(emptysat):-1:1);
                for i=1:length(emptysat)
                   Galileo_A(emptysat(i),:) = [];
                   Galileo_p(emptysat(i))   = [];
                end
            end
            emptysat         = [];
        else
            Galileo_A       =   [];
            Galileo_p       =   [];
            Galileo_CN0     =   [];
            Galileo_tcorr   =   [];
            Galileo_Pcorr   =   [];
        end
        
        %% Multiconstellation settings (GPS + Galileo)
        % Add multiconstellation column
        if iter == 1
            if acq_info.flags.constellations.GPS && acq_info.flags.constellations.Galileo
                GPS_A       =   [GPS_A zeros(length(GPS_A), 1)];
                Galileo_A   =   [Galileo_A ones(length(Galileo_A), 1)];
            end
        end
        
        % Multiconstellation unions
        G       =   [GPS_A; Galileo_A];
        p       =   [GPS_p; Galileo_p];
        CN0     =   [GPS_CN0 Galileo_CN0];
        
        %% Add last column  
        G = [G ones(length(G), 1)];
        
        if size(G, 1) >= (3 + acq_info.flags.constellations.GPS + acq_info.flags.constellations.Galileo)
            %% Weighting matrix
            if acq_info.flags.algorithm.WLS
                W   =   compute_Wmatrix(CN0);
            else
                W   =   eye(length(G));
            end

            %% LS corrections
            H               =   inv(G'*W*G);
            d               =   H*G'*W*p;         % PVT update
            PVT(1:3)        =   PVT(1:3) + d(1:3)';  % Update the PVT coords.
            PVT(4)          =   PVT(4) + d(4)/c;     % Update receiver clock offset
            
            GDOP    =   sqrt(H(1,1) + H(2,2) + H(3,3) + H(4,4));
            PDOP    =   sqrt(H(1,1) + H(2,2) + H(3,3));
            TDOP    =   sqrt(H(4,4));
        else
            PVT     =   [0 0 0 0];
            fprintf('Not enough satellites. Number is %G, needed: %G\n', size(G, 1), ((3 + acq_info.flags.constellations.GPS + acq_info.flags.constellations.Galileo)));
        end
        %
    end
    
    %fprintf('\nGDOP: %f', GDOP);
    %fprintf('\nPDOP: %f', PDOP);
    %fprintf('\nTDOP: %f\n\n:', TDOP);
    %tcorr   =   [GPS_tcorr' Galileo_tcorr];
    %Pcorr   =   [GPS_Pcorr Galileo_Pcorr];
    %tcorr = mean(tcorr);
    %Pcorr = mean(Pcorr);
end

%% Test code

    % Have to delete de duplicated satellites?
%     svn         =   (unique(svn', 'rows'))';
%     pr          =   pr(1:length(svn));

%             % Delete rows of 0s
%             for i=1:length(GPS_A)
%                 if GPS_A(i,:) == 0
%                     emptysat = [emptysat i];
%                 end
%             end
%             for i=1:length(emptysat)
%                GPS_A(emptysat(i),:) = [];
%                GPS_p(emptysat(i))   = [];
%                emptysat         = []; 
%             end
