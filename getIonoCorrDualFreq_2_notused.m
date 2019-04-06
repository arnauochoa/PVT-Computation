function [Pif, Ierr] = getIonoCorrDualFreq_2(pr1,pr5,f1,f5,TGD,system_control)


%- Inputs: 
%       pr1: L1/E1 Pseudorange measurement
%       pr5: L5/E5 Pseudorange measurement
%       f1 : L1/E1 Frequency
%       f5 : L5/E5 Frequency
%       TGD: Time Group Delay
%       const: 
%- Outputs:
%       Pif :  
%       Ierr: 
%


if system_control   
    TGD = 0; 
end       
% Phi parameter requiered:
phi    = (f1/f5)^2;
% IonosPhere-Free Combination:
Pif    = (pr5-phi*pr1)/(1-phi) - c*TGD;
% Ionosphere Error: 
Ierr   = pr1-Pif;
end