function    [I5, Iphase5, idx]     =   getIonoCorrDualFreq(system)
% getIonoCorr:  Get Iono effects correction.  
%
% Inputs:
%           - System    The system whose iono corrections wants to be known
%
% Outputs:
%           - I5: Pseudorange correction at L1 using L5 pr measurements
%           - Iphase5: Phase correction at L1 using L5 ph measurements
%           - TEC5: Total electron content computed from L1-L5 comb.

%% General declarations
c           =   299792458; 
L1          =   1575.42e6;  % Hz
L5          =   1176.45e6;  % Hz
DCBcond     =   1;
idx         =   [];
pr          =   [];
pr5         =   [];
p           =   [];
p5          =   [];

%% Obtaining data

tmp = system;
for i=1:length(system)
    for j=1:length(tmp)
        if system(i).svid == system(j).svid && i ~= j
            if system(i).carrierFreq > (L1 - 0.01*L1) && system(i).carrierFreq < (L1 + 0.01*L1)
                pr      =   [pr system(i).p];
                ph     	=   [p system(i).phase];
                idx     =   [idx i];
            else
                pr5     =   [pr5 system(i).p];
                ph5    	=   [p5 system(i).phase];
            end
        end
    end
end

%% Ionofree Correction combining PR_L1 & PR_L5
    if pr5            
        tmp     =   (L5^2)/( (L1^2) - (L5^2) );
        tmp2    =   pr5 - pr;
        tmp3    =   (1/L1^2)/( (1/L5)^2 - (1/L1)^2);
        I5      =   tmp*tmp2; 

        if(DCBcond == 1)
            I5  =   I5/(tmp3);  
        end  

        % TEC computation                
        TEC5    =   (I5* (L1^2) )/40.3;	
    else
        TEC5    =   NaN;
        I5      =   NaN;     
    end
    
%% Ionofree Correction combining Phase_L1 & Phase_L5
    
    lam1    =   c/L1;
    lam2    = c/L5;
    
    if ph5
        tmp         =   (L5^2)/( (L1^2) - (L5^2) );
        tmp2        =   (lam1*(ph)-lam2*(ph5));
        tmp3        =   (1/L1^2)/( (1/L5)^2 - (1/L1)^2);
        Iphase5     =   -tmp*tmp2; 

        if(DCBcond)
           Iphase5  = Iphase5/(tmp3);  
        end
    else
        Iphase5     = NaN;
    end
       
    
    
    
 
end