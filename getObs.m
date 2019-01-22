function    [Obs1,Obs2,Obs5,Obs6,Obs7,svn]    =   getObs(fid,Nsvn,Nobs,vers,const,Obs_types)
% getObs:   Get the observations of the selected epoch in a RINEX file.
%           Reads observations of Nsvn satellites. The selected epoch is
%           given by the position of the fid. It controls the RINEX version
%           given by vers = {2,3} for RINEX 2.XX or 3.XX, resp. For version
%           3, the function also outputs the SVN (string) in the given
%           epoch.
%
% Modified from Kai Borre 09-13-96

    global lin

    
    % Get number ob observation lines for each epoch/svn
    if( vers == 2)  % RINEX 2.XX (only 5 types of observation per line)
        Obs     =   nan(Nsvn,Nobs);
        Nlin    =   ceil(Nobs/5);
        svn     =   [];
        [tmp,~] =   obs_type_find(Obs_types,{const},'L1');
        colc    =   tmp.C1; 
    else            % RINEX 3.XX (All observation in the same line/svn)
        Nlin    =   1;
        svn     =   [];
        Obs5     =   [];
        Obs2     =   [];
        Obs1     =   [];
        Obs6     =   [];
        Obs7     =   [];
        switch const
            case 'GPS'
                strc    =   'G';            % Constellation letter for GPS
            case 'GAL'
                strc    =   'E';  
        end
         
        %para pr L1
        [tmp1,~]         =   obs_type_find(Obs_types,{const},'L1'); %%%
        colc1            =   tmp1.(const).C1;    
       
        %para pr L2 (no hay valores)
        [tmp2,~]         =   obs_type_find(Obs_types,{const},'L2'); %%%
        colc2            =   tmp2.(const).C2;    
        %para pr L5
        [tmp5,~]         =   obs_type_find(Obs_types,{const},'L5'); %%%
        colc5            =   tmp5.(const).C5;   
        %para fase L1
        [tmp6,~]         =   obs_type_find(Obs_types,{const},'L1'); %%%
        colc6            =   tmp6.(const).L1;  
        %para fase L5
        [tmp7,~]         =   obs_type_find(Obs_types,{const},'L5'); %%%
        colc7            =   tmp6.(const).L5;
        
        
      
    
    end
    
    %
    %-  Read line for each satellite
    % para VERSION 2 :::::::::::::::::::::::::::::::::::::::::::::::
    for ii = 1:Nsvn
        if( vers == 2 )
            for jj = 1:Nlin
                lin     =   fgetl(fid);     % Get line jj for SVN ii
                init    =   (jj-1)*5;
                if( jj == Nlin )
                    Ntmp    =   Nobs - init;
                else
                    Ntmp    =   5;
                end
                %-  Store each observable (Code Pseudorange) in the
                %   corresponding position of the satellite svn(ii)
                init        =   1+16*(colc-1);
                fin         =   16*colc-2;
                pr          =   str2num(lin(init:fin));
                if isempty(pr)
                    Obs     =   [Obs NaN];
                else
                    Obs     =   [Obs pr];
                end
            end        
        else
   %:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
   %:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


   %Para versión 3: 
   
   
            lin             =   fgetl(fid);     % Get line for SVN ii
             
            
            %estamos usando una sola linea para obtener todos los valores,
            %por lo tanto todos ellos corresponden al mismo satelite.
            
            
            if( strcmp(lin(1),strc) ) %comprueba si hay 'G' al principio de linea
                
                                
                svn         =   [svn str2num(lin(2:3))];       % Check format RINEX 3.XX
                %-  Store each observable (Code Pseudorange) in the
                %   corresponding position of the satellite svn(ii)
                
                %para pr L1 
                init1        =   3+1+16*(colc1-1);
                fin1         =   16*colc1-2+3;
                pr1          =   str2num(lin(init1:fin1));

                %para  pr L2 
                init2        =   3+1+16*(colc2-1);
                fin2         =   16*colc2-2+3;

                %para pr L5 
                init5        =   3+1+16*(colc5-1);
                fin5         =   16*colc5-2+3;
                %para fase L1 
                init6        =   3+1+16*(colc6-1);
                fin6         =   16*colc6-2+3;
                pL1          =   str2num(lin(init6:fin6));
                %para fase L5 
                init7        =   3+1+16*(colc7-1);
                fin7         =   16*colc7-2+3;

                %%%%%
                
                %Observaciones: 
                
                % Para el caso de C1 y L1 hay medidas siempre por lo tanto
                % las obtenemos directamente. Para el resto tendremos que
                % comprobar si excedemos el tamaño de la linea, de lo
                % contrario dara error. 
             
                %Obtenemos las porciones de linea necesarias para obtener
                %los valores si esta cumple con las dimensiones que le
                %corresponde al valor a observar.
                
                                
                %para  pr L2            
                if(length(lin)> init2)   
                pr2          =   str2num(lin(init2:fin2));%pr2
                else   
                pr2=0;    
                end
                %para pr L5 
                if(length(lin)> init5) 
                pr5          =   str2num(lin(init5:fin5));%pr5
                else  
                pr5=0;
                end
                %para fase L5 
                 if(length(lin)> init7) 
                pL5          =   str2num(lin(init7:fin7));%pr5
                else  
                pL5=0;
                 end
                
                
                 
                % Crearemos los vectores, y en los casos en los que no hay
                % medida asignaremos un 0.
                 
                if isempty(pr1)              
                    Obs1     =   [Obs1 NaN];
                else
                    Obs1     =   [Obs1 pr1];
                end
                
                 if isempty(pr2)
                                    
                    Obs2     =   [Obs2 NaN];
                else
                    Obs2     =   [Obs2 pr2];
                 end
                if isempty(pr5)
                    
                    Obs5     =   [Obs5 NaN];        
                else
                    Obs5     =   [Obs5 pr5];
                end
                if isempty(pL1)
                    
                    Obs6     =   [Obs6 NaN];        
                else
                    Obs6     =   [Obs6 pL1];
                end
                 if isempty(pL5)
                    
                    Obs7     =   [Obs7 NaN];        
                else
                    Obs7     =   [Obs7 pL5];
                end
                 
                
                
                
            end
        end
    end

end