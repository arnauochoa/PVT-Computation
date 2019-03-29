


function [IPRs] = smoothing4(Ipr, Iph, th)

%- Input
% Ipr: Nx1 vector containing Code Iono measurements from a SV.
% Iph: Nx1 vector containing all Phase Iono measurements from a SV
% th: Threshold allowed so as to avoid phase slips

%- Output
% IPRs: Nx1 vector containing the Iono code measurements smoothed using phase
% measurements. 

flagy = 1;
for i = 1:length(Ipr)

    if Ipr(i) && Iph(i)
        
            if i == 1 || flagy == 1
                IPRs(i) = Ipr(i);
                flagy = 0;
            else
                
                Aph = Iph(i) - Iph(i-1);
                
                if abs(Aph)<th
                    IPRs(i) = (1/i)*Ipr(i)+ ((i-1)/i)*(IPRs(i-1) +(Aph)); 
                else
                    IPRs(i)=Ipr(i);
                end
                
            end
    
    else
        IPRs(i)=Ipr(i); 
        flagy = 1;
        
    end
end



end

    