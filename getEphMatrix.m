function [eph, iono]    =   getEphMatrix(SVinfo, flags)

%% GPS
if flags.constellations.GPS
    GPS     =   SVinfo.GPS;
    eph     =   zeros(22, length(GPS));
    
    for i=1:length(GPS)
        eph(1, i)       =   GPS(i).svid;
        eph(2, i)       =   GPS(i).af2; %doubt
        eph(3, i)       =   GPS(i).keplerModel.m0; %doubt
        eph(4, i)       =   GPS(i).keplerModel.sqrtA;
        eph(5, i)       =   GPS(i).keplerModel.deltaN;
        eph(6, i)       =   GPS(i).keplerModel.eccentricity;
        eph(7, i)       =   GPS(i).keplerModel.omega;
        eph(8, i)       =   GPS(i).keplerModel.cuc;
        eph(9, i)       =   GPS(i).keplerModel.cus;
        eph(10, i)      =   GPS(i).keplerModel.crc;
        eph(11, i)      =   GPS(i).keplerModel.crs;
        eph(12, i)      =   GPS(i).keplerModel.i0;
        eph(13, i)      =   GPS(i).keplerModel.iDot;
        eph(14, i)      =   GPS(i).keplerModel.cic;
        eph(15, i)      =   GPS(i).keplerModel.cis;
        eph(16, i)      =   GPS(i).keplerModel.omega0;
        eph(17, i)      =   GPS(i).keplerModel.omegaDot;
        eph(18, i)      =   GPS(i).keplerModel.toeS;
        eph(19, i)      =   GPS(i).af0;
        eph(20, i)      =   GPS(i).af1;
        eph(21, i)      =   GPS(i).keplerModel.toeS;
        eph(22, i)      =   GPS(i).tgdS;
    end
    
end

%% Galileo

if flags.constellations.Galileo
    Galileo     =   SVinfo.Galileo;
    eph     =   zeros(22, length(Galileo));
    
    for i=1:length(Galileo)
        eph(1, i)       =   Galileo(i).svid;
        eph(2, i)       =   Galileo(i).af2; %doubt
        eph(3, i)       =   Galileo(i).keplerModel.m0; %doubt
        eph(4, i)       =   Galileo(i).keplerModel.sqrtA;
        eph(5, i)       =   Galileo(i).keplerModel.deltaN;
        eph(6, i)       =   Galileo(i).keplerModel.eccentricity;
        eph(7, i)       =   Galileo(i).keplerModel.omega;
        eph(8, i)       =   Galileo(i).keplerModel.cuc;
        eph(9, i)       =   Galileo(i).keplerModel.cus;
        eph(10, i)      =   Galileo(i).keplerModel.crc;
        eph(11, i)      =   Galileo(i).keplerModel.crs;
        eph(12, i)      =   Galileo(i).keplerModel.i0;
        eph(13, i)      =   Galileo(i).keplerModel.iDot;
        eph(14, i)      =   Galileo(i).keplerModel.cic;
        eph(15, i)      =   Galileo(i).keplerModel.cis;
        eph(16, i)      =   Galileo(i).keplerModel.omega0;
        eph(17, i)      =   Galileo(i).keplerModel.omegaDot;
        eph(18, i)      =   Galileo(i).keplerModel.toeS;
        eph(19, i)      =   Galileo(i).af0;
        eph(20, i)      =   Galileo(i).af1;
        eph(21, i)      =   Galileo(i).keplerModel.toeS;
        eph(22, i)      =   Galileo(i).tgdS;
    end
end

%% Results

iono =  [0 0 0 0 0 0 0 0]';

end