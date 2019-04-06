function    [Pif,I,I2,sats]     =   getIonoCorrDualFreq_GPS(f1,f5, pr1, pr5, tgd)
% getProp_tcorr:  Get propagation effects correction.  
%
% Inputs:
%           - f1:    Frequency of the band 1     [Hz]
%           - f5:    Frequency of the band 2     [Hz]
%           - pr1:   Pseudoranges and SVID of the satellites of the band 1
%           - pr2:   Pseudoranges and SVID of the satellites of the band
%           - tgd:   Time Group Delay (Ephemeris)
% Outputs:

%           - Pif:      Iono-Free Pseudoranges
%           - I:        Ionosphere correction at f1 using f2 meas.
%           - I2:       Ionosphere correction using Pr1-Pif combination.
%           - Sats:     Satellites involved in the measurements.
%
            

%%

c  = 299792458;

%% General algorithm, correction for band2
alfa1 = f5^2/(f1^2-f5^2);
phi    = (f1/f5)^2;

[sats, idx1, idx2]  =   intersect(pr1(1, :), pr5(1, :));
[~,~,idx3]          =   intersect(pr1(1,:),tgd(1,:));

for oo = 1:length(sats)
   
   I(oo)   =  alfa1*(pr5(2, idx2(oo))-pr1(2,idx1(oo)));
   Pif(oo) =  (pr5(2, idx2(oo))-phi*pr1(2,idx1(oo)))/(1-phi) - c*tgd(2,idx3(oo)); 
   I2(oo)  = pr1(2,idx1(oo))- Pif(oo);
 
end
    
 
end