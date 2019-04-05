function [pr,svn,CN0]     =   getMeas(meas)

%     Nsvn        =   length(meas);
    pr          =   [acq_info.satellites.gpsSatellites.gpsL1.pR]';
    svn         =   [acq_info.satellites.gpsSatellites.gpsL1.svid]';
    CN0         =   [acq_info.satellites.gpsSatellites.gpsL1.cn0]';
    
end