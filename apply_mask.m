function acq_info = apply_mask(acq_info, maskType, maskValue)

    % Elevation mask
    if maskType == 1
        tmp     =   [];
        if acq_info.flags.constellations.GPS
            for i=1:length(acq_info.SV.GPS)
                if acq_info.SV.GPS(i).Elevation < maskValue
                    tmp                     =   [tmp i]; 
                end
            end
            tmp     = 	sort(tmp, 'descend');
            for i=1:length(tmp)
                acq_info.SV.GPS(tmp(i))   	=   [];
            end
        end

        tmp     =   [];
        if acq_info.flags.constellations.Galileo
            for i=1:length(acq_info.SV.Galileo)
                if acq_info.SV.Galileo(i).Elevation < maskValue
                    tmp                     =   [tmp i];
                end        
            end
            tmp     = 	sort(tmp, 'descend');
            for i=1:length(tmp)
                acq_info.SV.Galileo(tmp(i))	=   [];
            end
        end
    end

    % CN0 mask
    if maskType == 2
        tmp         =   [];
        if acq_info.flags.constellations.GPS
            for i=1:length(acq_info.SV.GPS)
                if acq_info.SV.GPS(i).CN0 < maskValue
                    tmp                     =   [tmp i]; 
                end
            end
            tmp     = 	sort(tmp, 'descend');
            for i=1:length(tmp)
                acq_info.SV.GPS(tmp(i))   	=   [];
            end
        end

        tmp     =   [];
        if acq_info.flags.constellations.Galileo
            for i=1:length(acq_info.SV.Galileo)
                if acq_info.SV.Galileo(i).CN0 < maskValue
                    tmp                     =   [tmp i];
                end        
            end
            tmp     = 	sort(tmp, 'descend');
            for i=1:length(tmp)
                acq_info.SV.Galileo(tmp(i))	=   [];
            end
        end
    end
end