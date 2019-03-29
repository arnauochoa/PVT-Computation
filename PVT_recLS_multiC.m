function    [PVT, DOP, Corr, NS, error]  =   PVT_recLS_multiC(acq_info, eph)
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
    c                   =   299792458; 
    L1                  =   1575.42e6;
    L5                  =   1176.45e6;
    Nit                 =   5; 
    emptysat            =   [];
    GPS_tropoCorr       =   0;
    GPS_ionoCorr        =   0;
    Galileo_tropoCorr   =   0;
    Galileo_ionoCorr    =   0;
    error.flag          =   0;
    error.text          =   '';
    e_t                 =   0;
    
    %% LS loop
    for iter = 1:Nit
        % Declarations
        if (iter == 1)
            PVT0  	=   [acq_info.refLocation.XYZ 0];
            PVT     =   [acq_info.refLocation.XYZ 0];
            iono    =   acq_info.ionoProto;
        end
        
        %% GPS loop
        if acq_info.flags.constellations.GPS
            
            if (iter == 1)
                
                if acq_info.flags.constellations.GPSL1
                    nGPS            =   length(acq_info.SV.GPS.GPSL1);
                    GPS_A           =   zeros(nGPS, 3);
                    GPS_p           =   zeros(nGPS, 1);
                    GPS_tcorr       =   zeros(nGPS, 1);
                    GPS_Pcorr       =   zeros(nGPS, 1);
                    GPS_X           =   zeros(3, nGPS);
                    GPS_pr          =   [];
                    GPS_svn         =   [];
                    GPS_CN0         =   [];
                    for i=1:nGPS
                        GPS_pr      =   [GPS_pr acq_info.SV.GPS.GPSL1(i).p];
                        GPS_svn     =   [GPS_svn acq_info.SV.GPS.GPSL1(i).svid];
                        GPS_CN0     =   [GPS_CN0 acq_info.SV.GPS.GPSL1(i).CN0];
                    end
                    GPS_eph         =   eph.GPSL1;
                else
                    nGPS            =   length(acq_info.SV.GPS.GPSL5);
                    GPS_A           =   zeros(nGPS, 3);
                    GPS_p           =   zeros(nGPS, 1);
                    GPS_tcorr       =   zeros(nGPS, 1);
                    GPS_Pcorr       =   zeros(nGPS, 1);
                    GPS_X           =   zeros(3, nGPS);
                    GPS_pr          =   [];
                    GPS_svn         =   [];
                    GPS_CN0         =   [];
                    for i=1:nGPS
                        GPS_pr      =   [GPS_pr acq_info.SV.GPS.GPSL5(i).p];
                        GPS_svn     =   [GPS_svn acq_info.SV.GPS.GPSL5(i).svid];
                        GPS_CN0     =   [GPS_CN0 acq_info.SV.GPS.GPSL5(i).CN0];
                    end    
                    GPS_eph         =   eph.GPSL5;
                end
            end
        
            for sat = 1:nGPS                
                %% GPS corrections
                % GPS satellite coordinates and time correction (always applying)
                if (iter == 1)
                    [GPS_X(:, sat), GPS_tcorr(sat)]  =   getCtrl_corr(GPS_eph, GPS_svn(sat), acq_info.TOW, GPS_pr(sat));
                end
                GPS_corr                =   c * GPS_tcorr(sat);
                
                % Another GPS corrections (depending on flags)
                
                % Ionosphere and troposphere corrections
                if acq_info.flags.corrections.ionosphere || acq_info.flags.corrections.troposphere
                    [GPS_tropoCorr, GPS_ionoCorr]           =   getProp_corr(GPS_X(:, sat), PVT, iono, acq_info.TOW);  % Iono + Tropo correction
                    if acq_info.flags.corrections.troposphere 
                        GPS_corr            =   GPS_corr - GPS_tropoCorr; % troposphere correction
                    else
                        GPS_tropoCorr      	=   0;
                    end
                    if acq_info.flags.corrections.ionosphere
                        GPS_corr            =   GPS_corr - GPS_ionoCorr; % ionosphere correction
                    else
                        GPS_ionoCorr      	=   0;
                    end
                else
                    
                end
                
                % Ionosphere correction based on dual frequency
                if iter == 1
                    if acq_info.flags.corrections.f2corr
                        
                        if acq_info.flags.constellations.GPSL1
                            GPS_prcorr2f   =   getIonoCorrDualFreq(L5, L1, [acq_info.SV.GPS.GPSL5.svid; acq_info.SV.GPS.GPSL5.p], [acq_info.SV.GPS.GPSL1.svid; acq_info.SV.GPS.GPSL1.p]); % correction for E1
                        else
                            GPS_prcorr2f   =   getIonoCorrDualFreq(L1, L5, -[acq_info.SV.GPS.GPSL1.svid; acq_info.SV.GPS.GPSL1.p], -[acq_info.SV.GPS.GPSL5.svid; acq_info.SV.GPS.GPSL5.p]); % correction for E5a
                        end

                        GPS_pr   =   GPS_pr - GPS_prcorr2f; 
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
                for i=1:size(GPS_A, 1)
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
            GPS_A           =   [];
            GPS_p           =   [];
            GPS_CN0         =   [];
            GPS_tcorr       =   [];
            GPS_Pcorr       =   [];
        end

        %% Galileo loop
        if acq_info.flags.constellations.Galileo
            
            if (iter == 1)
                
                if acq_info.flags.constellations.GalileoE1
                    nGalileo            = length(acq_info.SV.Galileo.GalileoE1);
                    Galileo_A           =   zeros(nGalileo, 3);
                    Galileo_p           =   zeros(nGalileo, 1);
                    %tcorr       =   zeros(nGalileo, 1);
                    %Pcorr       =   zeros(nGalileo, 1);
                    %X           =   zeros(3, nGalileo);
                    Galileo_pr          =   [];
                    Galileo_svn         =   [];
                    Galileo_CN0         =   [];
                    for i=1:nGalileo
                        Galileo_pr      =   [Galileo_pr acq_info.SV.Galileo.GalileoE1(i).p];
                        Galileo_svn     =   [Galileo_svn acq_info.SV.Galileo.GalileoE1(i).svid];
                        Galileo_CN0     =   [Galileo_CN0 acq_info.SV.Galileo.GalileoE1(i).CN0];
                    end
                    Galileo_eph         =   eph.GalileoE1;
                else
                    nGalileo            = length(acq_info.SV.Galileo.GalileoE5a);
                    Galileo_A           =   zeros(nGalileo, 3);
                    Galileo_p           =   zeros(nGalileo, 1);
                    %tcorr       =   zeros(nGalileo, 1);
                    %Pcorr       =   zeros(nGalileo, 1);
                    %X           =   zeros(3, nGalileo);
                    Galileo_pr          =   [];
                    Galileo_svn         =   [];
                    Galileo_CN0         =   [];
                    for i=1:nGalileo
                        Galileo_pr      =   [Galileo_pr acq_info.SV.Galileo.GalileoE5a(i).p];
                        Galileo_svn     =   [Galileo_svn acq_info.SV.Galileo.GalileoE5a(i).svid];
                        Galileo_CN0     =   [Galileo_CN0 acq_info.SV.Galileo.GalileoE5a(i).CN0];
                    end
                    Galileo_eph         =   eph.GalileoE5a;
                end
            end
            
            for sat = 1:nGalileo
                %% Galileo corrections
                % Galileo satellite coordinates and time correction (always applying)
                if (iter == 1)  % Only 1st iteration
                    [Galileo_X(:, sat), Galileo_tcorr(sat)]  =   getCtrl_corr(Galileo_eph, Galileo_svn(sat), acq_info.TOW, Galileo_pr(sat));
                end
                Galileo_corr                =   c * Galileo_tcorr(sat);
                
                % Another Galileo corrections (depending on flags)
                
                % Ionosphere and troposphere corrections
                if acq_info.flags.corrections.ionosphere || acq_info.flags.corrections.troposphere
                    [Galileo_tropoCorr, Galileo_ionoCorr]           =   getProp_corr(Galileo_X(:, sat), PVT, iono, acq_info.TOW);  % Iono + Tropo correction
                    if acq_info.flags.corrections.troposphere 
                        Galileo_corr            =   Galileo_corr - Galileo_tropoCorr; % troposphere correction
                    else
                        Galileo_tropoCorr    	=   0;
                    end
                    if acq_info.flags.corrections.ionosphere
                        Galileo_corr            =   Galileo_corr - Galileo_ionoCorr; % ionosphere correction
                    else
                        Galileo_ionoCorr      	=   0;
                    end
                end
                
                % Ionosphere correction based on dual frequency
                if iter == 1
                    if acq_info.flags.corrections.f2corr
                        
                        if acq_info.flags.constellations.GalileoE1
                            Galileo_prcorr2f   =   getIonoCorrDualFreq(L5, L1, [acq_info.SV.Galileo.GalileoE5a.svid; acq_info.SV.Galileo.GalileoE5a.p], [acq_info.SV.Galileo.GalileoE1.svid; acq_info.SV.Galileo.GalileoE1.p]); % correction for E1
                        else
                            Galileo_prcorr2f   =   getIonoCorrDualFreq(L1, L5, -[acq_info.SV.Galileo.GalileoE1.svid; acq_info.SV.Galileo.GalileoE1.p], -[acq_info.SV.Galileo.GalileoE5a.svid; acq_info.SV.Galileo.GalileoE5a.p]); % correction for E5a
                        end

                        Galileo_pr   =   Galileo_pr - Galileo_prcorr2f; 
                    end
                end
                
                % Corrections application
                Galileo_pr_c                =   Galileo_pr(sat) + Galileo_corr;   %   Corrected pseudorange
                
                %% Galileo geometric matrix generation
                if (~isnan(Galileo_pr_c))    % Fill as long as there is C1 measurement,
                                     % otherwise discard the measurement.
                    %--     Fill the measurement vector (rhoc_i - d0_i)
                    %Galileo_d0              = sqrt((Galileo_X(1,sat) - PVT(1))^2 + (Galileo_X(2,sat) - PVT(2))^2 + (Galileo_X(3,sat) - PVT(3))^2); %TODO: shorten
                    Galileo_d0              =   sqrt(sum((Galileo_X(:,sat) - PVT(1:3)').^2));
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
                for i=1:size(Galileo_A, 1)
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
            Galileo_A           =   [];
            Galileo_p           =   [];
            Galileo_CN0         =   [];
            Galileo_tcorr       =   [];
            Galileo_Pcorr       =   [];
        end
        
        %% pseudorange "RAIM"
        % GPS
        if acq_info.flags.constellations.GPS
            if length(GPS_p) > 3
                [~, idxp]   =   outliers(GPS_p, length(GPS_p));

                idxp = sort(idxp, 'descend');
                for ii=1:length(idxp)
                    GPS_p(idxp(ii))     =   [];
                    GPS_A(idxp(ii), :)	=   [];
                    GPS_CN0(idxp(i))    =   [];
                end    
                idxp = [];
            end
        end
        
        % Galileo
        if acq_info.flags.constellations.Galileo
            if length(Galileo_p) > 3
                [~, idxp]   =   outliers(Galileo_p, length(Galileo_p));

                idxp = sort(idxp, 'descend');
                for ii=1:length(idxp)
                    Galileo_p(idxp(ii))     =   [];
                    Galileo_A(idxp(ii), :)	=   [];
                    Galileo_CN0(idxp(i))    =   [];
                end    
                idxp = [];
            end
        end

        %% Multiconstellation settings (GPS + Galileo)
        % Add multiconstellation column
        if acq_info.flags.constellations.GPS && acq_info.flags.constellations.Galileo
            GPS_A(:, 4)       =   zeros(size(GPS_A, 1), 1);
            Galileo_A(:, 4)   =   ones(size(Galileo_A, 1), 1);
        end
        
        % Multiconstellation unions
        G       =   [GPS_A; Galileo_A];
        p       =   [GPS_p; Galileo_p];
        CN0     =   [GPS_CN0 Galileo_CN0];
               
        %% Add last column  
        G = [G ones(size(G, 1), 1)];
        
        if size(G, 1) >= (3 + acq_info.flags.constellations.GPS + acq_info.flags.constellations.Galileo)     
            %% Weighting matrix
            if acq_info.flags.algorithm.WLS
                W   =   compute_Wmatrix(CN0);
            else
                W   =   eye(size(G, 1));
            end

            %% LS corrections
            H               =   inv(G'*W*G);
            d               =   H*G'*W*p;            % PVT update
            PVT(1:3)        =   PVT(1:3) + d(1:3)';  % Update the PVT coords.
            PVT(4)          =   PVT(4) + d(4)/c;     % Update receiver clock offset
            
            p_est           =   G*d;
            residue         =   p - p_est;
            
            GDOP            =   sqrt(H(1,1) + H(2,2) + H(3,3) + H(4,4));
            PDOP            =   sqrt(H(1,1) + H(2,2) + H(3,3));
            TDOP            =   sqrt(H(4,4));
            DOP             =   [GDOP, PDOP, TDOP];
            Corr.GPS        =   [GPS_ionoCorr GPS_tropoCorr];
            Corr.Galileo    =   [Galileo_ionoCorr Galileo_tropoCorr];
            NS              =   size(G, 1);
            
            
        else
            error.flag = 1;
            error.text = 'Not enough satellites';
            PVT     =   [0 0 0 0];
            DOP   	=   [];
            Corr    =   [];
            NS      =   0;
        end
        %
    end
     
    % Trick: don't accept executions with an error exceeding a fixed
    % threshold
%     e_t = sqrt((acq_info.refLocation.XYZ(1)-PVT(1))^2 + (acq_info.refLocation.XYZ(2)-PVT(2))^2 + (acq_info.refLocation.XYZ(3)-PVT(3))^2);
%     if e_t > 1000
%         error.flag = 1;
%         error.text = 'Bad data';
%         PVT     =   [0 0 0 0];
%         DOP   	=   [];
%         Corr    =   [];
%         NS      =   0;
%     end
    

end

    %fprintf('\nGDOP: %f', GDOP);
    %fprintf('\nPDOP: %f', PDOP);
    %fprintf('\nTDOP: %f\n\n:', TDOP);
    %tcorr   =   [GPS_tcorr' Galileo_tcorr];
    %Pcorr   =   [GPS_Pcorr Galileo_Pcorr];
    %tcorr = mean(tcorr);
    %Pcorr = mean(Pcorr);
    
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
