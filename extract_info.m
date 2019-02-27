function acq_info = extract_info(GNSS_info)

% Checking all the struct and separing into constellations

%% Initial declarations

acq_info.SV_list.SVlist_GPS         =   [];
acq_info.SV_list.SVlist_SBAS        =   [];
acq_info.SV_list.SVlist_GLONASS     =   [];
acq_info.SV_list.SVlist_QZSS        =   [];
acq_info.SV_list.SVlist_BEIDOU      =   [];
acq_info.SV_list.SVlist_Galileo     =   [];
acq_info.SV_list.SVlist_UNK         =   [];
c                                   =   299792458;

%% Flags
acq_info.flags      =   GNSS_info.Params;

%% Location
acq_info.refLocation.LLH = [GNSS_info.Location.latitude GNSS_info.Location.longitude GNSS_info.Location.altitude];
acq_info.refLocation.XYZ = lla2ecef(acq_info.refLocation.LLH); 

%% Clock info
acq_info.nsrxTime = GNSS_info.Clock.timeNanos;
if GNSS_info.Clock.hasBiasNanos
    acq_info.nsGPSTime =  (acq_info.nsrxTime - (GNSS_info.Clock.biasNanos + GNSS_info.Clock.fullBiasNanos));
end
[tow, now]      = nsgpst2gpst(acq_info.nsGPSTime);
acq_info.TOW    = tow;
acq_info.NOW    = now;

%% Status

% for i=1:length(GNSS_info.Status)
% 
%     switch GNSS_info.Status(i).constellationType
%         case 1
%             acq_info.SV_list.SVlist_GPS                                                 = [acq_info.SV_list.SVlist_GPS GNSS_info.Status(i).svid];
%             acq_info.SV.GPS(length(acq_info.SV_list.SVlist_GPS)).svid                   = GNSS_info.Status(i).svid;
%             acq_info.SV.GPS(length(acq_info.SV_list.SVlist_GPS)).CN0                    = GNSS_info.Status(i).cn0DbHz;
%             acq_info.SV.GPS(length(acq_info.SV_list.SVlist_GPS)).Azimuth                = GNSS_info.Status(i).azimuthDegrees;
%             acq_info.SV.GPS(length(acq_info.SV_list.SVlist_GPS)).Elevation              = GNSS_info.Status(i).elevationDegrees;
%             acq_info.SV.GPS(length(acq_info.SV_list.SVlist_GPS)).CarrierFreq            = GNSS_info.Status(i).carrierFrequencyHz;
%             acq_info.SV.GPS(length(acq_info.SV_list.SVlist_GPS)).OK                     = GNSS_info.Status(i).hasEphemerisData;
%         case 2
%             acq_info.SV_list.SVlist_SBAS                                                = [acq_info.SV_list.SVlist_SBAS GNSS_info.Status(i).svid];
%             acq_info.SV.SBAS(length(acq_info.SV_list.SVlist_SBAS)).svid                 = GNSS_info.Status(i).svid;
%             acq_info.SV.SBAS(length(acq_info.SV_list.SVlist_SBAS)).CN0                  = GNSS_info.Status(i).cn0DbHz;
%             acq_info.SV.SBAS(length(acq_info.SV_list.SVlist_SBAS)).Azimuth              = GNSS_info.Status(i).azimuthDegrees;
%             acq_info.SV.SBAS(length(acq_info.SV_list.SVlist_SBAS)).Elevation            = GNSS_info.Status(i).elevationDegrees;
%             acq_info.SV.SBAS(length(acq_info.SV_list.SVlist_SBAS)).CarrierFreq          = GNSS_info.Status(i).carrierFrequencyHz;
%             acq_info.SV.SBAS(length(acq_info.SV_list.SVlist_SBAD)).OK                   = GNSS_info.Status(i).hasEphemerisData;
%         case 3
%             acq_info.SV_list.SVlist_GLONASS                                             = [acq_info.SV_list.SVlist_GLONASS GNSS_info.Status(i).svid];
%             acq_info.SV.GLONASS(length(acq_info.SV_list.SVlist_GLONASS)).svid           = GNSS_info.Status(i).svid;
%             acq_info.SV.GLONASS(length(acq_info.SV_list.SVlist_GLONASS)).CN0            = GNSS_info.Status(i).cn0DbHz;
%             acq_info.SV.GLONASS(length(acq_info.SV_list.SVlist_GLONASS)).Azimuth        = GNSS_info.Status(i).azimuthDegrees;
%             acq_info.SV.GLONASS(length(acq_info.SV_list.SVlist_GLONASS)).Elevation      = GNSS_info.Status(i).elevationDegrees;
%             acq_info.SV.GLONASS(length(acq_info.SV_list.SVlist_GLONASS)).CarrierFreq    = GNSS_info.Status(i).carrierFrequencyHz;
%             acq_info.SV.GLONASS(length(acq_info.SV_list.SVlist_GLONASS)).OK             = GNSS_info.Status(i).hasEphemerisData;
%         case 4
%             acq_info.SV_list.SVlist_QZSS                                                = [acq_info.SV_list.SVlist_QZSS GNSS_info.Status(i).svid];
%             acq_info.SV.QZSS(length(acq_info.SV_list.SVlist_QZSS)).svid                 = GNSS_info.Status(i).svid;
%             acq_info.SV.QZSS(length(acq_info.SV_list.SVlist_QZSS)).CN0                  = GNSS_info.Status(i).cn0DbHz;
%             acq_info.SV.QZSS(length(acq_info.SV_list.SVlist_QZSS)).Azimuth              = GNSS_info.Status(i).azimuthDegrees;
%             acq_info.SV.QZSS(length(acq_info.SV_list.SVlist_QZSS)).Elevation            = GNSS_info.Status(i).elevationDegrees;
%             acq_info.SV.QZSS(length(acq_info.SV_list.SVlist_QZSS)).CarrierFreq          = GNSS_info.Status(i).carrierFrequencyHz;
%             acq_info.SV.QZSS(length(acq_info.SV_list.SVlist_QZSS)).OK                   = GNSS_info.Status(i).hasEphemerisData;
%         case 5
%             acq_info.SV_list.SVlist_BEIDOU                                              = [acq_info.SV_list.SVlist_BEIDOU GNSS_info.Status(i).svid];
%             acq_info.SV.BEIDOU(length(acq_info.SV_list.SVlist_BEIDOU)).svid             = GNSS_info.Status(i).svid;
%             acq_info.SV.BEIDOU(length(acq_info.SV_list.SVlist_BEIDOU)).CN0              = GNSS_info.Status(i).cn0DbHz;
%             acq_info.SV.BEIDOU(length(acq_info.SV_list.SVlist_BEIDOU)).Azimuth          = GNSS_info.Status(i).azimuthDegrees;
%             acq_info.SV.BEIDOU(length(acq_info.SV_list.SVlist_BEIDOU)).Elevation        = GNSS_info.Status(i).elevationDegrees;
%             acq_info.SV.BEIDOU(length(acq_info.SV_list.SVlist_BEIDOU)).CarrierFreq      = GNSS_info.Status(i).carrierFrequencyHz;
%             acq_info.SV.BEIDOU(length(acq_info.SV_list.SVlist_BEIDOU)).OK               = GNSS_info.Status(i).hasEphemerisData;
%         case 6
%             acq_info.SV_list.SVlist_Galileo                                             = [acq_info.SV_list.SVlist_Galileo GNSS_info.Status(i).svid];
%             acq_info.SV.Galileo(length(acq_info.SV_list.SVlist_Galileo)).svid           = GNSS_info.Status(i).svid;
%             acq_info.SV.Galileo(length(acq_info.SV_list.SVlist_Galileo)).CN0            = GNSS_info.Status(i).cn0DbHz;
%             acq_info.SV.Galileo(length(acq_info.SV_list.SVlist_Galileo)).Azimuth        = GNSS_info.Status(i).azimuthDegrees;
%             acq_info.SV.Galileo(length(acq_info.SV_list.SVlist_Galileo)).Elevation      = GNSS_info.Status(i).elevationDegrees;
%             acq_info.SV.Galileo(length(acq_info.SV_list.SVlist_Galileo)).CarrierFreq    = GNSS_info.Status(i).carrierFrequencyHz;
%             acq_info.SV.Galileo(length(acq_info.SV_list.SVlist_Galileo)).OK          	= GNSS_info.Status(i).hasEphemerisData;
%         otherwise
%             acq_info.SV_list.SVlist_UNK                                                 = [acq_info.SV_list.SVlist_UNK GNSS_info.Status(i).svid];
%             acq_info.SV.UNK(length(acq_info.SV_list.SVlist_UNK)).svid                   = GNSS_info.Status(i).svid;
%             acq_info.SV.UNK(length(acq_info.SV_list.SVlist_UNK)).CN0                    = GNSS_info.Status(i).cn0DbHz;
%             acq_info.SV.UNK(length(acq_info.SV_list.SVlist_UNK)).Azimuth                = GNSS_info.Status(i).azimuthDegrees;
%             acq_info.SV.UNK(length(acq_info.SV_list.SVlist_UNK)).Elevation              = GNSS_info.Status(i).elevationDegrees;
%             acq_info.SV.UNK(length(acq_info.SV_list.SVlist_UNK)).CarrierFreq            = GNSS_info.Status(i).carrierFrequencyHz;
%             acq_info.SV.UNK(length(acq_info.SV_list.SVlist_UNK)).OK                     = GNSS_info.Status(i).hasEphemerisData;
%     end
% 
% end

%% Measurements

nGPS        =   1;
nSBAS       =   1;
nGLONASS    =   1;
nQZSS       =   1;
nBEIDOU     =   1;
nGalileo    =   1;
nUNK        =   1;

for i=1:length(GNSS_info.Meas)

    switch GNSS_info.Meas(i).constellationType
        case 1
            acq_info.SV.GPS(nGPS).svid                      =   GNSS_info.Meas(i).svid;
            acq_info.SV.GPS(nGPS).carrierFreq               =   GNSS_info.Meas(i).carrierFrequencyHz;
            acq_info.SV.GPS(nGPS).t_tx                      =   GNSS_info.Meas(i).receivedSvTimeNanos;
            acq_info.SV.GPS(nGPS).pseudorangeRate           =   GNSS_info.Meas(i).pseudorangeRateMetersPerSecond;
            acq_info.SV.GPS(nGPS).CN0                       =   GNSS_info.Meas(i).cn0DbHz;
            acq_info.SV.GPS(nGPS).p                         =   pseudo_gen(acq_info.SV.GPS(nGPS).t_tx, tow, c);
            nGPS                                            =   nGPS + 1;
        case 2
            acq_info.SV.SBAS(nSBAS).svid                    =   GNSS_info.Meas(i).svid;
            acq_info.SV.SBAS(nSBAS).carrierFreq             =   GNSS_info.Meas(i).carrierFrequencyHz;
            acq_info.SV.SBAS(nSBAS).t_tx                    =   GNSS_info.Meas(i).receivedSvTimeNanos;
            acq_info.SV.SBAS(nSBAS).pseudorangeRate         =   GNSS_info.Meas(i).pseudorangeRateMetersPerSecond;
            acq_info.SV.SBAS(nSBAS).CN0                     =   GNSS_info.Meas(i).cn0DbHz;
            nSBAS                                           =   nSBAS + 1;
        case 3
            acq_info.SV.GLONASS(nGLONASS).svid           	=   GNSS_info.Meas(i).svid;
            acq_info.SV.GLONASS(nGLONASS).carrierFreq     	=   GNSS_info.Meas(i).carrierFrequencyHz;
            acq_info.SV.GLONASS(nGLONASS).t_tx              =   GNSS_info.Meas(i).receivedSvTimeNanos;
            acq_info.SV.GLONASS(nGLONASS).pseudorangeRate   =   GNSS_info.Meas(i).pseudorangeRateMetersPerSecond;
            acq_info.SV.GLONASS(nGLONASS).CN0               =   GNSS_info.Meas(i).cn0DbHz;
            nGLONASS                                        =   nGLONASS + 1;
        case 4
            acq_info.SV.QZSS(nQZSS).svid                    =   GNSS_info.Meas(i).svid;
            acq_info.SV.QZSS(nQZSS).carrierFreq             =   GNSS_info.Meas(i).carrierFrequencyHz;
            acq_info.SV.QZSS(nQZSS).t_tx                    =   GNSS_info.Meas(i).receivedSvTimeNanos;
            acq_info.SV.QZSS(nQZSS).pseudorangeRate         =   GNSS_info.Meas(i).pseudorangeRateMetersPerSecond;
            acq_info.SV.QZSS(nQZSS).CN0                     =   GNSS_info.Meas(i).cn0DbHz;
            nQZSS                                           =   nQZSS + 1;

        case 5
            acq_info.SV.BEIDOU(nBEIDOU).svid                =   GNSS_info.Meas(i).svid;
            acq_info.SV.BEIDOU(nBEIDOU).carrierFreq      	=   GNSS_info.Meas(i).carrierFrequencyHz;
            acq_info.SV.BEIDOU(nBEIDOU).t_tx                =   GNSS_info.Meas(i).receivedSvTimeNanos;
            acq_info.SV.BEIDOU(nBEIDOU).pseudorangeRate     =   GNSS_info.Meas(i).pseudorangeRateMetersPerSecond;
            acq_info.SV.BEIDOU(nBEIDOU).CN0                 =   GNSS_info.Meas(i).cn0DbHz;
            nBEIDOU                                         =   nBEIDOU + 1;
        case 6
            acq_info.SV.Galileo(nGalileo).svid           	=   GNSS_info.Meas(i).svid;
            acq_info.SV.Galileo(nGalileo).carrierFreq    	=   GNSS_info.Meas(i).carrierFrequencyHz;
            acq_info.SV.Galileo(nGalileo).t_tx              =   GNSS_info.Meas(i).receivedSvTimeNanos;
            acq_info.SV.Galileo(nGalileo).pseudorangeRate   =   GNSS_info.Meas(i).pseudorangeRateMetersPerSecond;
            acq_info.SV.Galileo(nGalileo).CN0               =   GNSS_info.Meas(i).cn0DbHz;
            acq_info.SV.Galileo(nGalileo).p                 =   pseudo_gen(acq_info.SV.Galileo(nGalileo).t_tx, tow, c);
            nGalileo                                        =   nGalileo + 1;
        otherwise
            acq_info.SV.UNK(nUNK).svid                      =   GNSS_info.Meas(i).svid;
            acq_info.SV.UNK(nUNK).carrierFreq               =   GNSS_info.Meas(i).carrierFrequencyHz;
            acq_info.SV.UNK(nUNK).t_tx                      =   GNSS_info.Meas(i).receivedSvTimeNanos;
            acq_info.SV.UNK(nUNK).pseudorangeRate           =   GNSS_info.Meas(i).pseudorangeRateMetersPerSecond;
            acq_info.SV.UNK(nUNK).CN0                       =   GNSS_info.Meas(i).cn0DbHz;
            nUNK                                            =   nUNK + 1;
    end
end

% Sat number correction
nGPS        =   nGPS - 1;
nSBAS       =   nSBAS - 1;
nGLONASS    =   nGLONASS - 1;
nQZSS       =   nQZSS - 1;
nBEIDOU     =   nBEIDOU - 1;
nGalileo    =   nGalileo - 1;
nUNK        =   nUNK - 1;
%% SUPL information

% GPS

for i=1:length(GNSS_info.ephData.GPS)
    for j=1:nGPS
        if acq_info.SV.GPS(j).svid == GNSS_info.ephData.GPS(i).svid
            
            acq_info.SV.GPS(j).TOW                          =   GNSS_info.ephData.GPS(i).tocS;
            acq_info.SV.GPS(j).NOW                          =   GNSS_info.ephData.GPS(i).week;
            acq_info.SV.GPS(j).af0                          =   GNSS_info.ephData.GPS(i).af0S;
            acq_info.SV.GPS(j).af1                          =   GNSS_info.ephData.GPS(i).af1SecPerSec;
            acq_info.SV.GPS(j).af2                          =   GNSS_info.ephData.GPS(i).af2SecPerSec2;
            acq_info.SV.GPS(j).tgdS                         =   GNSS_info.ephData.GPS(i).tgdS;
            
            % Kepler Model
            acq_info.SV.GPS(j).keplerModel.cic              =   GNSS_info.ephData.GPS(i).keplerModel.cic;
            acq_info.SV.GPS(j).keplerModel.cis              =   GNSS_info.ephData.GPS(i).keplerModel.cis;
            acq_info.SV.GPS(j).keplerModel.crc              =   GNSS_info.ephData.GPS(i).keplerModel.crc;
            acq_info.SV.GPS(j).keplerModel.crs              =   GNSS_info.ephData.GPS(i).keplerModel.crs;
            acq_info.SV.GPS(j).keplerModel.cuc              =   GNSS_info.ephData.GPS(i).keplerModel.cuc;
            acq_info.SV.GPS(j).keplerModel.cus              =   GNSS_info.ephData.GPS(i).keplerModel.cus;
            acq_info.SV.GPS(j).keplerModel.deltaN           =   GNSS_info.ephData.GPS(i).keplerModel.deltaN;
            acq_info.SV.GPS(j).keplerModel.eccentricity     =   GNSS_info.ephData.GPS(i).keplerModel.eccentricity;
            acq_info.SV.GPS(j).keplerModel.i0               =   GNSS_info.ephData.GPS(i).keplerModel.i0;
            acq_info.SV.GPS(j).keplerModel.iDot             =   GNSS_info.ephData.GPS(i).keplerModel.iDot;
            acq_info.SV.GPS(j).keplerModel.m0               =   GNSS_info.ephData.GPS(i).keplerModel.m0;
            acq_info.SV.GPS(j).keplerModel.omega            =   GNSS_info.ephData.GPS(i).keplerModel.omega;
            acq_info.SV.GPS(j).keplerModel.omega0           =   GNSS_info.ephData.GPS(i).keplerModel.omega0;
            acq_info.SV.GPS(j).keplerModel.omegaDot         =   GNSS_info.ephData.GPS(i).keplerModel.omegaDot;
            acq_info.SV.GPS(j).keplerModel.sqrtA            =   GNSS_info.ephData.GPS(i).keplerModel.sqrtA;
            acq_info.SV.GPS(j).keplerModel.toeS             =   GNSS_info.ephData.GPS(i).keplerModel.toeS;
            
        end
    end
end

% Galileo
for i=1:length(GNSS_info.ephData.Galileo)
    for j=1:nGalileo
        if acq_info.SV.Galileo(j).svid == GNSS_info.ephData.Galileo(i).svid
            acq_info.SV.Galileo(j).TOW                          =   GNSS_info.ephData.Galileo(i).tocS;
            acq_info.SV.Galileo(j).NOW                          =   GNSS_info.ephData.Galileo(i).week;
            acq_info.SV.Galileo(j).af0                          =   GNSS_info.ephData.Galileo(i).af0S;
            acq_info.SV.Galileo(j).af1                          =   GNSS_info.ephData.Galileo(i).af1SecPerSec;
            acq_info.SV.Galileo(j).af2                          =   GNSS_info.ephData.Galileo(i).af2SecPerSec2;
            acq_info.SV.Galileo(j).tgdS                         =   GNSS_info.ephData.Galileo(i).tgdS;
            
            % Kepler Model
            acq_info.SV.Galileo(j).keplerModel.cic              =   GNSS_info.ephData.Galileo(i).keplerModel.cic;
            acq_info.SV.Galileo(j).keplerModel.cis              =   GNSS_info.ephData.Galileo(i).keplerModel.cis;
            acq_info.SV.Galileo(j).keplerModel.crc              =   GNSS_info.ephData.Galileo(i).keplerModel.crc;
            acq_info.SV.Galileo(j).keplerModel.crs              =   GNSS_info.ephData.Galileo(i).keplerModel.crs;
            acq_info.SV.Galileo(j).keplerModel.cuc              =   GNSS_info.ephData.Galileo(i).keplerModel.cuc;
            acq_info.SV.Galileo(j).keplerModel.cus              =   GNSS_info.ephData.Galileo(i).keplerModel.cus;
            acq_info.SV.Galileo(j).keplerModel.deltaN           =   GNSS_info.ephData.Galileo(i).keplerModel.deltaN;
            acq_info.SV.Galileo(j).keplerModel.eccentricity     =   GNSS_info.ephData.Galileo(i).keplerModel.eccentricity;
            acq_info.SV.Galileo(j).keplerModel.i0               =   GNSS_info.ephData.Galileo(i).keplerModel.i0;
            acq_info.SV.Galileo(j).keplerModel.iDot             =   GNSS_info.ephData.Galileo(i).keplerModel.iDot;
            acq_info.SV.Galileo(j).keplerModel.m0               =   GNSS_info.ephData.Galileo(i).keplerModel.m0;
            acq_info.SV.Galileo(j).keplerModel.omega            =   GNSS_info.ephData.Galileo(i).keplerModel.omega;
            acq_info.SV.Galileo(j).keplerModel.omega0           =   GNSS_info.ephData.Galileo(i).keplerModel.omega0;
            acq_info.SV.Galileo(j).keplerModel.omegaDot         =   GNSS_info.ephData.Galileo(i).keplerModel.omegaDot;
            acq_info.SV.Galileo(j).keplerModel.sqrtA            =   GNSS_info.ephData.Galileo(i).keplerModel.sqrtA;
            acq_info.SV.Galileo(j).keplerModel.toeS             =   GNSS_info.ephData.Galileo(i).keplerModel.toeS;
             
        end
    end
end

% GLONASS
for i=1:length(GNSS_info.ephData.GLONASS)
    for j=1:nGLONASS
        if acq_info.SV.GLONASS(j).svid == GNSS_info.ephData.GLONASS(i).svid
            acq_info.SV.GLONASS(j).XYZ = [GNSS_info.ephData.GLONASS(i).xSatPosM ... 
                GNSS_info.ephData.GLONASS(i).ySatPosM ...
                GNSS_info.ephData.GLONASS(i).zSatPosM];
        end
    end
end

% ionoProto
acq_info.ionoProto                        =   [GNSS_info.ephData.ionoProto.alpha_; GNSS_info.ephData.ionoProto.beta_];

%% Number of total SV
acq_info.SVs = nGPS + nSBAS + nGLONASS + nQZSS + nBEIDOU + nGalileo + nUNK;
end