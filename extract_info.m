function acq_info = extract_info(GNSS_info)

% Checking all the struct and separing into constellations

%% Initial declarations

acq_info.SV_list.SVlist_GPS     = [];
acq_info.SV_list.SVlist_SBAS    = [];
acq_info.SV_list.SVlist_GLONASS = [];
acq_info.SV_list.SVlist_QZSS    = [];
acq_info.SV_list.SVlist_BEIDOU  = [];
acq_info.SV_list.SVlist_Galileo = [];
acq_info.SV_list.SVlist_UNK     = [];
c                               =   299792458;


%% Location
acq_info.refLocation.LLH = [GNSS_info.Location.latitude GNSS_info.Location.longitude GNSS_info.Location.altitude];
acq_info.refLocation.XYZ = lla2ecef(acq_info.refLocation.LLH); 

%% Clock info
acq_info.GPSTime = GNSS_info.Clock.timeNanos;
if GNSS_info.Clock.hasBiasNanos
    acq_info.GPSTime =  (acq_info.GPSTime - (GNSS_info.Clock.biasNanos + GNSS_info.Clock.fullBiasNanos));
end
[tow, now]      = nsgpst2gpst(acq_info.GPSTime);
acq_info.TOW    = tow;
acq_info.NOW    = now;

%% Status

for i=1:length(GNSS_info.Status)

    switch GNSS_info.Status(i).constellationType
        case 1
            acq_info.SV_list.SVlist_GPS                                                 = [acq_info.SV_list.SVlist_GPS GNSS_info.Status(i).svid];
            acq_info.SV.GPS(length(acq_info.SV_list.SVlist_GPS)).svid                   = GNSS_info.Status(i).svid;
            acq_info.SV.GPS(length(acq_info.SV_list.SVlist_GPS)).CN0                    = GNSS_info.Status(i).cn0DbHz;
            acq_info.SV.GPS(length(acq_info.SV_list.SVlist_GPS)).Azimuth                = GNSS_info.Status(i).azimuthDegrees;
            acq_info.SV.GPS(length(acq_info.SV_list.SVlist_GPS)).Elevation              = GNSS_info.Status(i).elevationDegrees;
            acq_info.SV.GPS(length(acq_info.SV_list.SVlist_GPS)).CarrierFreq            = GNSS_info.Status(i).carrierFrequencyHz;
            acq_info.SV.GPS(length(acq_info.SV_list.SVlist_GPS)).OK                     = GNSS_info.Status(i).hasEphemerisData;
        case 2
            acq_info.SV_list.SVlist_SBAS                                                = [acq_info.SV_list.SVlist_SBAS GNSS_info.Status(i).svid];
            acq_info.SV.SBAS(length(acq_info.SV_list.SVlist_SBAS)).svid                 = GNSS_info.Status(i).svid;
            acq_info.SV.SBAS(length(acq_info.SV_list.SVlist_SBAS)).CN0                  = GNSS_info.Status(i).cn0DbHz;
            acq_info.SV.SBAS(length(acq_info.SV_list.SVlist_SBAS)).Azimuth              = GNSS_info.Status(i).azimuthDegrees;
            acq_info.SV.SBAS(length(acq_info.SV_list.SVlist_SBAS)).Elevation            = GNSS_info.Status(i).elevationDegrees;
            acq_info.SV.SBAS(length(acq_info.SV_list.SVlist_SBAS)).CarrierFreq          = GNSS_info.Status(i).carrierFrequencyHz;
            acq_info.SV.SBAS(length(acq_info.SV_list.SVlist_SBAD)).OK                   = GNSS_info.Status(i).hasEphemerisData;
        case 3
            acq_info.SV_list.SVlist_GLONASS                                             = [acq_info.SV_list.SVlist_GLONASS GNSS_info.Status(i).svid];
            acq_info.SV.GLONASS(length(acq_info.SV_list.SVlist_GLONASS)).svid           = GNSS_info.Status(i).svid;
            acq_info.SV.GLONASS(length(acq_info.SV_list.SVlist_GLONASS)).CN0            = GNSS_info.Status(i).cn0DbHz;
            acq_info.SV.GLONASS(length(acq_info.SV_list.SVlist_GLONASS)).Azimuth        = GNSS_info.Status(i).azimuthDegrees;
            acq_info.SV.GLONASS(length(acq_info.SV_list.SVlist_GLONASS)).Elevation      = GNSS_info.Status(i).elevationDegrees;
            acq_info.SV.GLONASS(length(acq_info.SV_list.SVlist_GLONASS)).CarrierFreq    = GNSS_info.Status(i).carrierFrequencyHz;
            acq_info.SV.GLONASS(length(acq_info.SV_list.SVlist_GLONASS)).OK             = GNSS_info.Status(i).hasEphemerisData;
        case 4
            acq_info.SV_list.SVlist_QZSS                                                = [acq_info.SV_list.SVlist_QZSS GNSS_info.Status(i).svid];
            acq_info.SV.QZSS(length(acq_info.SV_list.SVlist_QZSS)).svid                 = GNSS_info.Status(i).svid;
            acq_info.SV.QZSS(length(acq_info.SV_list.SVlist_QZSS)).CN0                  = GNSS_info.Status(i).cn0DbHz;
            acq_info.SV.QZSS(length(acq_info.SV_list.SVlist_QZSS)).Azimuth              = GNSS_info.Status(i).azimuthDegrees;
            acq_info.SV.QZSS(length(acq_info.SV_list.SVlist_QZSS)).Elevation            = GNSS_info.Status(i).elevationDegrees;
            acq_info.SV.QZSS(length(acq_info.SV_list.SVlist_QZSS)).CarrierFreq          = GNSS_info.Status(i).carrierFrequencyHz;
            acq_info.SV.QZSS(length(acq_info.SV_list.SVlist_QZSS)).OK                   = GNSS_info.Status(i).hasEphemerisData;
        case 5
            acq_info.SV_list.SVlist_BEIDOU                                              = [acq_info.SV_list.SVlist_BEIDOU GNSS_info.Status(i).svid];
            acq_info.SV.BEIDOU(length(acq_info.SV_list.SVlist_BEIDOU)).svid             = GNSS_info.Status(i).svid;
            acq_info.SV.BEIDOU(length(acq_info.SV_list.SVlist_BEIDOU)).CN0              = GNSS_info.Status(i).cn0DbHz;
            acq_info.SV.BEIDOU(length(acq_info.SV_list.SVlist_BEIDOU)).Azimuth          = GNSS_info.Status(i).azimuthDegrees;
            acq_info.SV.BEIDOU(length(acq_info.SV_list.SVlist_BEIDOU)).Elevation        = GNSS_info.Status(i).elevationDegrees;
            acq_info.SV.BEIDOU(length(acq_info.SV_list.SVlist_BEIDOU)).CarrierFreq      = GNSS_info.Status(i).carrierFrequencyHz;
            acq_info.SV.BEIDOU(length(acq_info.SV_list.SVlist_BEIDOU)).OK               = GNSS_info.Status(i).hasEphemerisData;
        case 6
            acq_info.SV_list.SVlist_Galileo                                             = [acq_info.SV_list.SVlist_Galileo GNSS_info.Status(i).svid];
            acq_info.SV.Galileo(length(acq_info.SV_list.SVlist_Galileo)).svid           = GNSS_info.Status(i).svid;
            acq_info.SV.Galileo(length(acq_info.SV_list.SVlist_Galileo)).CN0            = GNSS_info.Status(i).cn0DbHz;
            acq_info.SV.Galileo(length(acq_info.SV_list.SVlist_Galileo)).Azimuth        = GNSS_info.Status(i).azimuthDegrees;
            acq_info.SV.Galileo(length(acq_info.SV_list.SVlist_Galileo)).Elevation      = GNSS_info.Status(i).elevationDegrees;
            acq_info.SV.Galileo(length(acq_info.SV_list.SVlist_Galileo)).CarrierFreq    = GNSS_info.Status(i).carrierFrequencyHz;
            acq_info.SV.Galileo(length(acq_info.SV_list.SVlist_Galileo)).OK          	= GNSS_info.Status(i).hasEphemerisData;
        otherwise
            acq_info.SV_list.SVlist_UNK                                                 = [acq_info.SV_list.SVlist_UNK GNSS_info.Status(i).svid];
            acq_info.SV.UNK(length(acq_info.SV_list.SVlist_UNK)).svid                   = GNSS_info.Status(i).svid;
            acq_info.SV.UNK(length(acq_info.SV_list.SVlist_UNK)).CN0                    = GNSS_info.Status(i).cn0DbHz;
            acq_info.SV.UNK(length(acq_info.SV_list.SVlist_UNK)).Azimuth                = GNSS_info.Status(i).azimuthDegrees;
            acq_info.SV.UNK(length(acq_info.SV_list.SVlist_UNK)).Elevation              = GNSS_info.Status(i).elevationDegrees;
            acq_info.SV.UNK(length(acq_info.SV_list.SVlist_UNK)).CarrierFreq            = GNSS_info.Status(i).carrierFrequencyHz;
            acq_info.SV.UNK(length(acq_info.SV_list.SVlist_UNK)).OK                     = GNSS_info.Status(i).hasEphemerisData;
    end

end

%% Measurements

for i=1:length(GNSS_info.Meas)

    switch GNSS_info.Meas(i).constellationType
        case 1
            for j=1:length(acq_info.SV_list.SVlist_GPS)
                if acq_info.SV.GPS(j).svid == GNSS_info.Meas(i).svid
                    acq_info.SV.GPS(j).t_tx                 = GNSS_info.Meas(i).receivedSvTimeNanos;
                    acq_info.SV.GPS(j).pseudorangeRate      = GNSS_info.Meas(i).pseudorangeRateMetersPerSecond;
                    acq_info.SV.GPS(j).CN0                  = GNSS_info.Meas(i).cn0DbHz;
                    acq_info.SV.GPS(j).p                    = pseudo_gen(acq_info.SV.GPS(j).t_tx, tow, c);
                end
            end
            
        case 2
            for j=1:length(acq_info.SV_list.SVlist_SBAS)
                if acq_info.SV.SBAS(j).svid == GNSS_info.Meas(i).svid
                    acq_info.SV.SBAS(j).t_tx                = GNSS_info.Meas(i).receivedSvTimeNanos;
                    acq_info.SV.SBAS(j).pseudorangeRate     = GNSS_info.Meas(i).pseudorangeRateMetersPerSecond;
                    acq_info.SV.SBAS(j).CN0                 = GNSS_info.Meas(i).cn0DbHz;
                end
            end
        case 3
            for j=1:length(acq_info.SV_list.SVlist_GLONASS)
                if acq_info.SV.GLONASS(j).svid == GNSS_info.Meas(i).svid
                    acq_info.SV.GLONASS(j).t_tx             = GNSS_info.Meas(i).receivedSvTimeNanos;
                    acq_info.SV.GLONASS(j).pseudorangeRate  = GNSS_info.Meas(i).pseudorangeRateMetersPerSecond;
                    acq_info.SV.GLONASS(j).CN0              = GNSS_info.Meas(i).cn0DbHz;
                end
            end
        case 4
            for j=1:length(acq_info.SV_list.SVlist_QZSS)
                if acq_info.SV.QZSS(j).svid == GNSS_info.Meas(i).svid
                    acq_info.SV.QZSS(j).t_tx                = GNSS_info.Meas(i).receivedSvTimeNanos;
                    acq_info.SV.QZSS(j).pseudorangeRate     = GNSS_info.Meas(i).pseudorangeRateMetersPerSecond;
                    acq_info.SV.QZSS(j).CN0                 = GNSS_info.Meas(i).cn0DbHz;
                end
            end
        case 5
            for j=1:length(acq_info.SV_list.SVlist_BEIDOU)
                if acq_info.SV.BEIDOU(j).svid == GNSS_info.Meas(i).svid
                    acq_info.SV.BEIDOU(j).t_tx              = GNSS_info.Meas(i).receivedSvTimeNanos;
                    acq_info.SV.BEIDOU(j).pseudorangeRate   = GNSS_info.Meas(i).pseudorangeRateMetersPerSecond;
                    acq_info.SV.BEIDOU(j).CN0               = GNSS_info.Meas(i).cn0DbHz;
                end
            end
        case 6
            for j=1:length(acq_info.SV_list.SVlist_Galileo)
                if acq_info.SV.Galileo(j).svid == GNSS_info.Meas(i).svid
                    acq_info.SV.Galileo(j).t_tx             = GNSS_info.Meas(i).receivedSvTimeNanos;
                    acq_info.SV.Galileo(j).pseudorangeRate  = GNSS_info.Meas(i).pseudorangeRateMetersPerSecond;
                    acq_info.SV.Galileo(j).CN0              = GNSS_info.Meas(i).cn0DbHz;
                end
            end
        otherwise
            for j=1:length(acq_info.SV_list.SVlist_UNK)
                if acq_info.SV.UNK(j).svid == GNSS_info.Meas(i).svid
                    acq_info.SV.UNK(j).t_tx                = GNSS_info.Meas(i).receivedSvTimeNanos;
                    acq_info.SV.UNK(j).pseudorangeRate      = GNSS_info.Meas(i).pseudorangeRateMetersPerSecond;
                    acq_info.SV.UNK(j).CN0                  = GNSS_info.Meas(i).cn0DbHz;
                end
            end
    end
end

%% Number of total SV
acq_info.SVs = length(acq_info.SV_list.SVlist_GPS)  + ...
    length(acq_info.SV_list.SVlist_SBAS)            + ...
    length(acq_info.SV_list.SVlist_GLONASS)         + ...
    length(acq_info.SV_list.SVlist_QZSS)            + ...
    length(acq_info.SV_list.SVlist_BEIDOU)          + ...
    length(acq_info.SV_list.SVlist_Galileo)         + ...
    length(acq_info.SV_list.SVlist_UNK);
end