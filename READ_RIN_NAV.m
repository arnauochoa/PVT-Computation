function [navmes,ionpar] = READ_RIN_NAV(navfile)
%**************************** FUNCTION DESCRIPTION ***********************************
% Reads a RINEX Navigation Message file and reformats the data into a matrix with 21
% rows and a column for each satellite at several points in time
%*********************************** INPUT *******************************************
% *** FILES
% navfile            RINEX 2 Navigation file - RINEX 3.0x Navigation file
%*********************************** OUTPUT ******************************************
% *** PARAMETERS
% navmes             navigation message matrix with information depending on type
%                    navigation file (GPS, GLONASS or SBAS), see code for contents
% ionpar (1x8)       Array of ionospheric parameters: a0,a1,a2,a3,b0,b1,b2,b3
%*********************************** HISTORY *****************************************
% Kai Borre                     September 1997
%                               First Programmed
% Vicente Lucas (SPCOMNAV)      November 2017
%                               Second Programmed - GPS Navigation Version 3.0x
% Jose A. Lopez-Salcedo			12 June 2018
%								Removed +2000 in year field of RINEX v3.0x when computing the toc time.


fide = fopen(navfile);

% Read first line of navigation file and detect type
line = fgetl(fide);
%disp(line);
typechar = line(21);
if typechar == 'N' 
    navtype = 1;
end
if typechar == 'G'
    navtype = 2;
end
if typechar == 'H'
    navtype = 3;
end
if typechar ~= 'N' & typechar ~= 'G' & typechar ~='H'
    error('No type of navigation file detected');
end      

if  navtype == 1,
    version = line(6);
    if version == '2'
        % Read untill ION ALPHA parameters line found
        linein = fgetl(fide);
        flag_version=0;
        while linein ~= -1
            linein = fgetl(fide);
            answer = findstr(linein,'ION ALPHA');
            if ~isempty(answer), flag_version=1; break; end;
        end
        if flag_version~=1
            %disp('line: # / ION ALPHA not found');
            ionpar(1:4)=0;
        else
            ionpar(1)=str2num(linein(3:14));
            ionpar(2)=str2num(linein(15:26));
            ionpar(3)=str2num(linein(27:38));
            ionpar(4)=str2num(linein(39:50));
        end
        % Display line and rewind file
        %disp(linein);
        frewind(fide);

        % Read untill ION BETA parameters line found
        linein = fgetl(fide);
        flag_version=0;
        while linein ~= -1
            linein = fgetl(fide);
            answer = findstr(linein,'ION BETA');
            if ~isempty(answer), flag_version=1; break; end;
        end
        if flag_version~=1
            %disp('line: # / ION BETA not found');
            ionpar(5:8)=0;
        else
            ionpar(5)=str2num(linein(3:14));
            ionpar(6)=str2num(linein(15:26));
            ionpar(7)=str2num(linein(27:38));
            ionpar(8)=str2num(linein(39:50));
        end
        % Display line and rewind file
        %disp(linein)
        frewind(fide);
    end
    if version == '3'
        % Read untill IONOSPHERIC CORR (1) parameters line found
        linein = fgetl(fide);
        flag_version=0;
        while linein ~= -1
            linein = fgetl(fide);
            answer = findstr(linein,'IONOSPHERIC CORR');
            if ~isempty(answer), flag_version=1; break; end;
        end
        if flag_version~=1
            %disp('line: # / IONOSPHERIC CORR not found');
            ionpar(1:4)=0;
        else
            ionpar(1)=str2num(linein(7:17));
            ionpar(2)=str2num(linein(19:29));
            ionpar(3)=str2num(linein(31:41));
            ionpar(4)=str2num(linein(43:53));
        end
        % Display line and rewind file
        %disp(linein);
        frewind(fide);
        
        % Read untill ION CORR (2) parameters line found
        linein = fgetl(fide);
        flag_version=0;
        while linein ~= -1
            linein = fgetl(fide);
            answer = findstr(linein,'GPSB');
            if ~isempty(answer), flag_version=1; break; end;
        end
        if flag_version~=1
            %disp('line: # / IONOSPHERIC CORR not found');
            ionpar(5:8)=0;
        else
            ionpar(5)=str2num(linein(7:17));
            ionpar(6)=str2num(linein(19:29));
            ionpar(7)=str2num(linein(31:41));
            ionpar(8)=str2num(linein(43:53));
        end
        % Display line and rewind file
        %disp(linein)
        frewind(fide);
    end
else
    ionpar=[];
end

while 1  % We skip header
    line = fgetl(fide);
    answer = findstr(line,'END OF HEADER');
    if ~isempty(answer), break;  end;
end;

if navtype == 1
    %*************************************************************************************
    % Read GPS lines
    i=0;
    line = fgetl(fide);
    %disp(line)
    if version == '2'
        while line ~= -1
            i=i+1;
            svprn(i) = str2num(line(1:2));
            tocyear(i) = str2num(line(3:6));
            tocmonth(i) = str2num(line(7:9));
            tocday(i) = str2num(line(10:12));
            tochour(i) = str2num(line(13:15));
            tocminute(i) = str2num(line(16:18));
            tocsecond(i) = str2num(line(19:22));
            out_mat = ymdhms2gps(tocyear(i)+2000,tocmonth(i),tocday(i),tochour(i),tocminute(i),tocsecond(i));
            tocgpswk(i)=out_mat(1); tocgpssow(i)=out_mat(2);
            af0(i) = str2num(line(23:41));
            af1(i) = str2num(line(42:60));
            af2(i) = str2num(line(61:79));
            line = fgetl(fide);
            iode(i) = str2num(line(4:22));
            crs(i) = str2num(line(23:41));
            deltan(i) = str2num(line(42:60));
            m0(i) = str2num(line(61:79));
            line = fgetl(fide);
            cuc(i) = str2num(line(4:22));
            e(i) = str2num(line(23:41));
            cus(i) = str2num(line(42:60));
            roota(i) = str2num(line(61:79));
            line=fgetl(fide);
            toe(i) = str2num(line(4:22));
            cic(i) = str2num(line(23:41));
            omega0(i) = str2num(line(42:60));
            cis(i) = str2num(line(61:79));
            line = fgetl(fide);
            i0(i) =  str2num(line(4:22));
            crc(i) = str2num(line(23:41));
            omega(i) = str2num(line(42:60));
            omegadot(i) = str2num(line(61:79));
            line = fgetl(fide);
            idot(i) = str2num(line(4:22));
            codes(i) = str2num(line(23:41));
            weekno(i) = str2num(line(42:60));
            pflag(i) = str2num(line(61:79));
            line = fgetl(fide);
            svaccuracy(i) = str2num(line(4:22));
            svhealth(i) = str2num(line(23:41));
            tgd(i) = str2num(line(42:60));
            iodc(i) = str2num(line(61:79));
            line = fgetl(fide);
            tom(i) = str2num(line(4:22));
            line = fgetl(fide);
        end
    end
    if version == '3'
        while ~feof(fide)
            i=i+1;
            svprn(i) = str2num(line(2:3));
            tocyear(i) = str2num(line(5:8));
            tocmonth(i) = str2num(line(10:11));
            tocday(i) = str2num(line(13:14));
            tochour(i) = str2num(line(16:17));
            tocminute(i) = str2num(line(19:20));
            tocsecond(i) = str2num(line(22:23));
            out_mat = ymdhms2gps(tocyear(i),tocmonth(i),tocday(i),tochour(i),tocminute(i),tocsecond(i));
            tocgpswk(i)=out_mat(1); tocgpssow(i)=out_mat(2);
            af0(i) = str2num(line(24:42));
            af1(i) = str2num(line(43:61));
            af2(i) = str2num(line(62:80));
            line = fgetl(fide);
            iode(i) = str2num(line(5:23));
            crs(i) = str2num(line(24:42));
            deltan(i) = str2num(line(43:61));
            m0(i) = str2num(line(62:80));
            line = fgetl(fide);
            cuc(i) = str2num(line(5:23));
            e(i) = str2num(line(24:42));
            cus(i) = str2num(line(43:61));
            roota(i) = str2num(line(62:80));
            line=fgetl(fide);
            toe(i) = str2num(line(5:23));
            cic(i) = str2num(line(24:42));
            omega0(i) = str2num(line(43:61));
            cis(i) = str2num(line(62:80));
            line = fgetl(fide);
            i0(i) =  str2num(line(5:23));
            crc(i) = str2num(line(24:42));
            omega(i) = str2num(line(43:61));
            omegadot(i) = str2num(line(62:80));
            line = fgetl(fide);
            idot(i) = str2num(line(5:23));
            codes(i) = str2num(line(24:42));
            weekno(i) = str2num(line(43:61));
            pflag(i) = str2num(line(62:80));
            line = fgetl(fide);
            svaccuracy(i) = str2num(line(5:23));
            svhealth(i) = str2num(line(24:42));
            tgd(i) = str2num(line(43:61));
            iodc(i) = str2num(line(62:80));
            line = fgetl(fide);
            tom(i) = str2num(line(5:23));
            line = fgetl(fide);
        end
    end
    status = fclose(fide);
    
    
    %  Description of variable navmes.
    navmes(1,:)  = svprn;    % Satellite PRN number  
    % Possible Y2K bug, because of RINEX format
    navmes(2,:)  = tocyear;  % Time of clock
    navmes(3,:)  = tocmonth; % Time of clock
    navmes(4,:)  = tocday;   % Time of clock
    navmes(5,:)  = tochour;  % Time of clock
    navmes(6,:)  = tocminute;% Time of clock
    navmes(7,:)  = tocsecond;% Time of clock
    navmes(8,:)  = af0;      % SV clock bias (seconds)  
    navmes(9,:)  = af1;      % SV clock drift (sec/sec)  
    navmes(10,:) = af2;      % SV clock drift rate (sec/sec2
    navmes(11,:) = iode;     % Issue of data ephemeris
    navmes(12,:) = crs;      % Harmonic correction sin orbit radius (meters)
    navmes(13,:) = deltan;   % Mean motion difference from computed value (radians/sec)
    navmes(14,:) = m0;       % Mean anomaly at reference time (radians)
    navmes(15,:) = cuc;      % Harmonic correction cos arg latitude (radians)
    navmes(16,:) = e;        % Eccentricity
    navmes(17,:) = cus;      % Harmonic correction sin arg latitude (radians
    navmes(18,:) = roota;    % Root semi major axis(sqrt(m))
    navmes(19,:) = toe;      % Time of Ephemeris (sec of GPS week)
    navmes(20,:) = cic;      % Harmonic correction cos inclination (radians)
    navmes(21,:) = omega0;   % Longitude ascending node at weekly epoch 
    navmes(22,:) = cis;      % Harmonic correction sin inclination (radians)
    navmes(23,:) = i0;       % Inclination angle at reference time (radians)  
    navmes(24,:) = crc;      % Harmonic correction cos orbit radius (meters)  
    navmes(25,:) = omega;    % Argument of perigee (radians)
    navmes(26,:) = omegadot; % Rate of right ascension (radians/sec
    navmes(27,:) = idot;     % Rate of inclination angle (radians/sec)
    navmes(28,:) = codes;    % Codes on L2 channel
    navmes(29,:) = weekno;   % GPS Week number, not mod(1024)
    navmes(30,:) = pflag;    % L2 P Flag data
    navmes(31,:) = svaccuracy;% Satellite accuracy (meters)
    navmes(32,:) = svhealth; % Satellite health (MSB only)
    navmes(33,:) = tgd;      % Group delay (seconds)
    navmes(34,:) = iodc;     % Issue of data clock
    navmes(35,:) = tom;      % Transmission of time of message (GPS seconds of week)
    navmes(36,:) = tocgpswk;      % Converted TOC into GPSWK
    navmes(37,:) = tocgpssow;      % Converted TOC into GPSSOW
    navmes(38,:) = tocgpswk*86400*7+tocgpssow;      % Converted TOC into full seconds after 1 Jan 1980 or so
end

if navtype==2
    %*************************************************************************************
    % Read GLONASS lines
    % TBD
    %
    i=0;
    line = fgetl(fide);
    while line ~= -1
        i=i+1;
        sv(i) = str2num(line(1:2));
        tutcyear(i) = str2num(line(3:6));
        tutcmonth(i) = str2num(line(7:9));
        tutcday(i) = str2num(line(10:12));
        tutchour(i) = str2num(line(13:15));
        tutcminute(i) = str2num(line(16:18));
        tutcsecond(i) = str2num(line(19:22));
        out_mat = ymdhms2gps(tutcyear(i)+2000,tutcmonth(i),tutcday(i),tutchour(i),tutcminute(i),tutcsecond(i));
        tutcgpswk(i)=out_mat(1);
        tutcgpssow(i)=out_mat(2);
        taun(i) = str2num(line(23:41));
        gamman(i) = str2num(line(42:60));
        mft(i) = str2num(line(61:79));
        line = fgetl(fide);	  %
        x(i) = str2num(line(4:22));
        xdot(i) = str2num(line(23:41));
        xacc(i) = str2num(line(42:60));
        svhealth(i) = str2num(line(61:79));
        line = fgetl(fide);	  %
        y(i) = str2num(line(4:22));
        ydot(i) = str2num(line(23:41));
        yacc(i) = str2num(line(42:60));
        freqnum(i) = str2num(line(61:79));
        line=fgetl(fide);
        z(i) = str2num(line(4:22));
        zdot(i) = str2num(line(23:41));
        zacc(i) = str2num(line(42:60));
        ageinfo(i) = str2num(line(61:79));
        line = fgetl(fide);
    end
    status = fclose(fide);
    
    %  Description of variable navmes.
    navmes(1,:)  = sv;        % Satellite almanac number  
    navmes(2,:)  = tutcyear;  % Epoch of ephemeris (UTC)
    navmes(3,:)  = tutcmonth; % Epoch of ephemeris (UTC)
    navmes(4,:)  = tutcday;   % Epoch of ephemeris (UTC)
    navmes(5,:)  = tutchour;  % Epoch of ephemeris (UTC)
    navmes(6,:)  = tutcminute;% Epoch of ephemeris (UTC)
    navmes(7,:)  = tutcsecond;% Epoch of ephemeris (UTC)
    navmes(8,:)  = taun;      % SV clock bias (seconds) (-Taun) 
    navmes(9,:)  = gamman;    % SV relative frequency bias (+GammaN)
    navmes(10,:) = mft;       % message frame time (sec of day UTC)
    navmes(11,:) = x;         % x position (km)
    navmes(12,:) = xdot;      % x velocity (km/s)
    navmes(13,:) = xacc;      % x accellaration (km/s2)
    navmes(14,:) = svhealth;  % 0=ok
    navmes(15,:) = y;         % y position (km)
    navmes(16,:) = ydot;      % y velocity (km/s)
    navmes(17,:) = yacc;      % y accellaration (km/s2)
    navmes(18,:) = freqnum;   % (1-24)
    navmes(19,:) = z;         % z velocity (km/s)
    navmes(20,:) = zdot;      % z velocity (km/s)
    navmes(21,:) = zacc;      % z accellaration (km/s2)
    navmes(22,:) = ageinfo;   % age of information (days)
    navmes(23,:) = tgd;       % Satellite group delay (sec)
    navmes(24,:) = tutcgpswk;        % Converted TOC into GPSWK
    navmes(25,:) = tutcgpssow;         % Converted TOC into GPSSOW
    navmes(26,:) = tutcgpswk*86400*7+tutcgpssow;      % Converted TOC into full seconds after 1 Jan 1980 or so
end

if navtype == 3
    %*************************************************************************************
    % Read GEO lines
    i=0;
    line = fgetl(fide);
    disp(line)
    while line ~= -1
        i=i+1;
        svprn(i) = str2num(line(1:2))+100;
        tocyear(i) = str2num(line(3:6));
        tocmonth(i) = str2num(line(7:9));
        tocday(i) = str2num(line(10:12));
        tochour(i) = str2num(line(13:15));
        tocminute(i) = str2num(line(16:18));
        tocsecond(i) = str2num(line(19:22));
        out_mat = ymdhms2gps(tocyear(i)+2000,tocmonth(i),tocday(i),tochour(i),tocminute(i),tocsecond(i));
        tocgpswk(i)=out_mat(1);
        tocgpssow(i)=out_mat(2);
        aGf0(i) = str2num(line(23:41));
        aGf1(i) = str2num(line(42:60));
        messfrmtime(i) = str2num(line(61:79));
        line = fgetl(fide);
        x(i) = str2num(line(4:22));
        xdot(i) = str2num(line(23:41));
        xacc(i) = str2num(line(42:60));
        health(i) = str2num(line(61:79));
        line = fgetl(fide);
        y(i) = str2num(line(4:22));
        ydot(i) = str2num(line(23:41));
        yacc(i) = str2num(line(42:60));
        ura(i) = str2num(line(61:79));
        line=fgetl(fide);
        z(i) = str2num(line(4:22));
        zdot(i) = str2num(line(23:41));
        zacc(i) = str2num(line(42:60));
        line=fgetl(fide);
    end
    status = fclose(fide);
    
    %  Description of variable navmes.
    navmes(1,:)  = svprn;    % Satellite PRN number  
    % Possible Y2K bug, because of RINEX format
    navmes(2,:)  = tocyear;  % Time of clock
    navmes(3,:)  = tocmonth; % Time of clock
    navmes(4,:)  = tocday;   % Time of clock
    navmes(5,:)  = tochour;  % Time of clock
    navmes(6,:)  = tocminute;% Time of clock
    navmes(7,:)  = tocsecond;% Time of clock
    navmes(8,:)  = aGf0;      % SV clock bias (seconds)  
    navmes(9,:)  = aGf1;      % SV clock drift (sec/sec)  
    navmes(10,:) = messfrmtime;      % SV clock drift rate (sec/sec2
    navmes(11,:) = x;     % Issue of data ephemeris
    navmes(12,:) = xdot;      % Harmonic correction sin orbit radius (meters)
    navmes(13,:) = xacc;   % Mean motion difference from computed value (radians/sec)
    navmes(14,:) = health;       % Mean anomaly at reference time (radians)
    navmes(15,:) = y;      % Harmonic correction cos arg latitude (radians)
    navmes(16,:) = ydot;        % Eccentricity
    navmes(17,:) = yacc;      % Harmonic correction sin arg latitude (radians
    navmes(18,:) = ura;    % Root semi major axis(sqrt(m))
    navmes(19,:) = z;      % Time of Ephemeris (sec of GPS week)
    navmes(20,:) = zdot;      % Harmonic correction cos inclination (radians)
    navmes(21,:) = zacc;   % Longitude ascending node at weekly epoch 
    navmes(22,:) = tocgpswk;      % Converted TOC into GPSWK
    navmes(23,:) = tocgpssow;      % Converted TOC into GPSSOW
    navmes(24,:) = tocgpswk*86400*7+tocgpssow;      % Converted TOC into full seconds after 1 Jan 1980 or so
end

% +----------------------------------------------------------------------------+
% |                                   TABLE A3                                 |
% |             NAVIGATION MESSAGE FILE - HEADER SECTION DESCRIPTION           |
% +--------------------+------------------------------------------+------------+
% |    HEADER LABEL    |               DESCRIPTION                |   FORMAT   |
% |  (Columns 61-80)   |                                          |            |
% +--------------------+------------------------------------------+------------+
% |RINEX VERSION / TYPE| - Format version (2)                     |   I6,14X,  |
% |                    | - File type ('N' for Navigation data)    |   A1,19X   |
% +--------------------+------------------------------------------+------------+
% |PGM / RUN BY / DATE | - Name of program creating current file  |     A20,   |
% |                    | - Name of agency  creating current file  |     A20,   |
% |                    | - Date of file creation                  |     A20    |
% +--------------------+------------------------------------------+------------+
%*|COMMENT             | Comment line(s)                          |     A60    |*
% +--------------------+------------------------------------------+------------+
%*|ION ALPHA           | Ionosphere parameters A0-A3 of almanac   |  2X,4D12.4 |*
% |                    | (page 18 of subframe 4)                  |            |
% +--------------------+------------------------------------------+------------+
%*|ION BETA            | Ionosphere parameters B0-B3 of almanac   |  2X,4D12.4 |*
% +--------------------+------------------------------------------+------------+
%*|DELTA-UTC: A0,A1,T,W| Almanac parameters to compute time in UTC| 3X,2D19.12,|*
% |                    | (page 18 of subframe 4)                  |     2I9    |
% |                    | A0,A1: terms of polynomial               |            |
% |                    | T    : reference time for UTC data       |            |
% |                    | W    : UTC reference week number.        |            |
% |                    |        Continuous number, not mod(1024)! |            |
% +--------------------+------------------------------------------+------------+
%*|LEAP SECONDS        | Delta time due to leap seconds           |     I6     |*
% +--------------------+------------------------------------------+------------+
% |END OF HEADER       | Last record in the header section.       |    60X     |
% +--------------------+------------------------------------------+------------+
%
%                        Records marked with * are optional
%
%
% +----------------------------------------------------------------------------+
% |                                  TABLE A4                                  |
% |             NAVIGATION MESSAGE FILE - DATA RECORD DESCRIPTION              |
% +--------------------+------------------------------------------+------------+
% |    OBS. RECORD     | DESCRIPTION                              |   FORMAT   |
% +--------------------+------------------------------------------+------------+
% |PRN / EPOCH / SV CLK| - Satellite PRN number                   |     I2,    |
% |                    | - Epoch: Toc - Time of Clock             |            |
% |                    |          year         (2 digits)         |    5I3,    |
% |                    |          month                           |            |
% |                    |          day                             |            |
% |                    |          hour                            |            |
% |                    |          minute                          |            |
% |                    |          second                          |    F5.1,   |
% |                    | - SV clock bias       (seconds)          |  3D19.12   |
% |                    | - SV clock drift      (sec/sec)          |            |
% |                    | - SV clock drift rate (sec/sec2)         |            |
% +--------------------+------------------------------------------+------------+
% | BROADCAST ORBIT - 1| - IODE Issue of Data, Ephemeris          | 3X,4D19.12 |
% |                    | - Crs                 (meters)           |            |
% |                    | - Delta n             (radians/sec)      |            |
% |                    | - M0                  (radians)          |            |
% +--------------------+------------------------------------------+------------+
% | BROADCAST ORBIT - 2| - Cuc                 (radians)          | 3X,4D19.12 |
% |                    | - e Eccentricity                         |            |
% |                    | - Cus                 (radians)          |            |
% |                    | - sqrt(A)             (sqrt(m))          |            |
% +--------------------+------------------------------------------+------------+
% | BROADCAST ORBIT - 3| - Toe Time of Ephemeris                  | 3X,4D19.12 |
% |                    |                       (sec of GPS week)  |            |
% |                    | - Cic                 (radians)          |            |
% |                    | - OMEGA               (radians)          |            |
% |                    | - CIS                 (radians)          |            |
% +--------------------+------------------------------------------+------------+
% | BROADCAST ORBIT - 4| - i0                  (radians)          | 3X,4D19.12 |
% |                    | - Crc                 (meters)           |            |
% |                    | - omega               (radians)          |            |
% |                    | - OMEGA DOT           (radians/sec)      |            |
% +--------------------+------------------------------------------+------------+
% | BROADCAST ORBIT - 5| - IDOT                (radians/sec)      | 3X,4D19.12 |
% |                    | - Codes on L2 channel                    |            |
% |                    | - GPS Week # (to go with TOE)            |            |
% |                    |   Continuous number, not mod(1024)!      |            |
% |                    | - L2 P data flag                         |            |
% +--------------------+------------------------------------------+------------+
% | BROADCAST ORBIT - 6| - SV accuracy         (meters)           | 3X,4D19.12 |
% |                    | - SV health           (MSB only)         |            |
% |                    | - TGD                 (seconds)          |            |
% |                    | - IODC Issue of Data, Clock              |            |
% +--------------------+------------------------------------------+------------+
% | BROADCAST ORBIT - 7| - Transmission time of message           | 3X,4D19.12 |
% |                    |         (sec of GPS week, derived e.g.   |            |
% |                    |    from Z-count in Hand Over Word (HOW)  |            |
% |                    | - spare                                  |            |
% |                    | - spare                                  |            |
% |                    | - spare                                  |            |
% +--------------------+------------------------------------------+------------+
%
%  +----------------------------------------------------------------------------+
%  |                                   TABLE A10                                |
%  |        GLONASS NAVIGATION MESSAGE FILE - HEADER SECTION DESCRIPTION        |
%  +--------------------+------------------------------------------+------------+
%  |    HEADER LABEL    |               DESCRIPTION                |   FORMAT   |
%  |  (Columns 61-80)   |                                          |            |
%  +--------------------+------------------------------------------+------------+
%  |RINEX VERSION / TYPE| - Format version (2.01)                  | F9.2,11X,  |#
%  |                    | - File type ('G' = GLONASS nav mess data)|   A1,39X   |
%  +--------------------+------------------------------------------+------------+
%  |PGM / RUN BY / DATE | - Name of program creating current file  |     A20,   |
%  |                    | - Name of agency  creating current file  |     A20,   |
%  |                    | - Date of file creation (dd-mmm-yy hh:mm)|     A20    |
%  +--------------------+------------------------------------------+------------+
% *|COMMENT             | Comment line(s)                          |     A60    |*
%  +--------------------+------------------------------------------+------------+
% *|CORR TO SYSTEM TIME | - Time of reference for system time corr |            |*
%  |                    |   (year, month, day)                     |     3I6,   |
%  |                    | - Correction to system time scale (sec)  |  3X,D19.12 |
%  |                    |   to correct GLONASS system time to      |            |
%  |                    |   UTC(SU)                         (-TauC)|            |
%  +--------------------+------------------------------------------+------------+
% *|LEAP SECONDS        | Number of leap seconds since 6-Jan-1980  |     I6     |*
%  +--------------------+------------------------------------------+------------+
%  |END OF HEADER       | Last record in the header section.       |    60X     |
%  +--------------------+------------------------------------------+------------+
% 
%                         Records marked with * are optional
% 
% 
%  +----------------------------------------------------------------------------+
%  |                                  TABLE A11                                 |
%  |         GLONASS NAVIGATION MESSAGE FILE - DATA RECORD DESCRIPTION          |
%  +--------------------+------------------------------------------+------------+
%  |    OBS. RECORD     | DESCRIPTION                              |   FORMAT   |
%  +--------------------+------------------------------------------+------------+
%  |PRN / EPOCH / SV CLK| - Satellite almanac number               |     I2,    |
%  |                    | - Epoch of ephemerides             (UTC) |            |
%  |                    |          - year (2 digits)               |    5I3,    |
%  |                    |          - month                         |            |
%  |                    |          - day                           |            |
%  |                    |          - hour                          |            |
%  |                    |          - minute                        |            |
%  |                    |          - second                        |    F5.1,   |
%  |                    | - SV clock bias (sec)             (-TauN)|   D19.12,  |
%  |                    | - SV relative frequency bias    (+GammaN)|   D19.12,  |
%  |                    | - message frame time (sec of day UTC)    |   D19.12   |
%  +--------------------+------------------------------------------+------------+
%  | BROADCAST ORBIT - 1| - Satellite position X      (km)         | 3X,4D19.12 |
%  |                    | -           velocity X dot  (km/sec)     |            |
%  |                    | -           X acceleration  (km/sec2)    |            |
%  |                    | -           health (0=OK)            (Bn)|            |
%  +--------------------+------------------------------------------+------------+
%  | BROADCAST ORBIT - 2| - Satellite position Y      (km)         | 3X,4D19.12 |
%  |                    | -           velocity Y dot  (km/sec)     |            |
%  |                    | -           Y acceleration  (km/sec2)    |            |
%  |                    | -           frequency number (1-24)      |            |
%  +--------------------+------------------------------------------+------------+
%  | BROADCAST ORBIT - 3| - Satellite position Z      (km)         | 3X,4D19.12 |
%  |                    | -           velocity Z dot  (km/sec)     |            |
%  |                    | -           Z acceleration  (km/sec2)    |            |
%  |                    | - Age of oper. information  (days)   (E) |            |
%  +--------------------+------------------------------------------+------------+
% 
% 
% +------------------------------------------------------------------------------+
% |                                   TABLE A12                                  |
% |                  GLONASS NAVIGATION MESSAGE FILE - EXAMPLE                   |
% +------------------------------------------------------------------------------+
% 
% ----|---1|0---|---2|0---|---3|0---|---4|0---|---5|0---|---6|0---|---7|0---|---8|
% 
%      2.01           GLONASS NAV DATA                        RINEX VERSION / TYPE
% ASRINEXG V1.1.0 VM  AIUB                19-FEB-98 10:42     PGM / RUN BY / DATE 
% STATION ZIMMERWALD                                          COMMENT             
%   1998     2    16    0.379979610443D-06                    CORR TO SYSTEM TIME 
%                                                             END OF HEADER       
%  3 98  2 15  0 15  0.0 0.163525342941D-03 0.363797880709D-11 0.108000000000D+05
%     0.106275903320D+05-0.348924636841D+00 0.931322574615D-09 0.000000000000D+00
%    -0.944422070313D+04 0.288163375854D+01 0.931322574615D-09 0.210000000000D+02
%     0.212257280273D+05 0.144599342346D+01-0.186264514923D-08 0.300000000000D+01
%  4 98  2 15  0 15  0.0 0.179599039257D-03 0.636646291241D-11 0.122400000000D+05
%     0.562136621094D+04-0.289074897766D+00-0.931322574615D-09 0.000000000000D+00
%    -0.236819248047D+05 0.102263259888D+01 0.931322574615D-09 0.120000000000D+02

%  +----------------------------------------------------------------------------+
%  |                                  TABLE A16                                 |
%  |      GEOSTATIONARY NAVIGATION MESSAGE FILE - DATA RECORD DESCRIPTION       |
%  +--------------------+------------------------------------------+------------+
%  |    OBS. RECORD     | DESCRIPTION                              |   FORMAT   |
%  +--------------------+------------------------------------------+------------+
%  |PRN / EPOCH / SV CLK| - Satellite number (PRN - 100)           |     I2,    |
%  |                    | - Epoch of ephemerides (GPS)       (Toe) |            |
%  |                    |     - year (2 digits, padded with 0      |            |
%  |                    |                if necessary)             |   1X,I2.2, |
%  |                    |     - month,day,hour,minute,             |  4(1X,I2), |
%  |                    |     - second                             |    F5.1,   |
%  |                    | - SV clock bias (sec)              (aGf0)|   D19.12,  |
%  |                    | - SV relative frequency bias       (aGf1)|   D19.12,  |
%  |                    | - message frame time (sec of day GPS)    |   D19.12   |
%  +--------------------+------------------------------------------+------------+
%  | BROADCAST ORBIT - 1| - Satellite position X      (km)         | 3X,4D19.12 |
%  |                    | -           velocity X dot  (km/sec)     |            |
%  |                    | -           X acceleration  (km/sec2)    |     *)     ||
%  |                    | -           health (0=OK)                |            |
%  +--------------------+------------------------------------------+------------+
%  | BROADCAST ORBIT - 2| - Satellite position Y      (km)         | 3X,4D19.12 |
%  |                    | -           velocity Y dot  (km/sec)     |            |
%  |                    | -           Y acceleration  (km/sec2)    |            |
%  |                    | - Accuracy code             (URA, meters)|            ||
%  +--------------------+------------------------------------------+------------+
%  | BROADCAST ORBIT - 3| - Satellite position Z      (km)         | 3X,4D19.12 |
%  |                    | -           velocity Z dot  (km/sec)     |            |
%  |                    | -           Z acceleration  (km/sec2)    |            |
%  |                    | - spare                                  |            |
%  +--------------------+------------------------------------------+------------+
% 
%  *) In order to account for the various compilers, E,e,D, and d are allowed
%     letters between the fraction and exponent of all floating point numbers
%     in the navigation message files.
%     Zero-padded two-digit exponents are required, however.
% 
% 
% 
% ----|---1|0---|---2|0---|---3|0---|---4|0---|---5|0---|---6|0---|---7|0---|---8|
% 
% +------------------------------------------------------------------------------+
% |                                   TABLE A18                                  |
% |                     GEO NAVIGATION MESSAGE FILE - EXAMPLE                    |
% +------------------------------------------------------------------------------+
% 
% ----|---1|0---|---2|0---|---3|0---|---4|0---|---5|0---|---6|0---|---7|0---|---8|
% 
%      2.10           H: GEO NAV MSG DATA                     RINEX VERSION / TYPE
% SuP v. 1.4          TESTUSER            04-02-00 10:04      PGM / RUN BY / DATE
%                                                             COMMENT
% The file contains navigation message data of the            COMMENT
% geostationary AOR-E satellite (PRN 120 = S20)               COMMENT
%                                                             COMMENT
%                                                             END OF HEADER
% 20 00 01 13 14 46 24.0  .209547579288D-07 -.545696821064D-11  .532351280000D+05
%      .406131052800D+08  .150625000000D+01  .875000000000D-04  .000000000000D+00
%     -.112454290400D+08  .308125000000D+01 -.112500000000D-03  .400000000000D+01
%      .781616000000D+05  .959600000000D+01 -.437500000000D-03  .000000000000D+00
% 20 00 01 13 14 48 00.0  .204890966415D-07 -.545696821064D-11  .533161280000D+05
%      .406132503200D+08  .151500000000D+01  .875000000000D-04  .000000000000D+00
%     -.112451338400D+08  .307000000000D+01 -.125000000000D-03  .400000000000D+01
%      .790812000000D+05  .955600000000D+01 -.437500000000D-03  .000000000000D+00
% 20 00 01 13 14 49 36.0  .195577740669D-07 -.545696821064D-11  .533981280000D+05
%      .406133961600D+08  .152375000000D+01  .875000000000D-04  .000000000000D+00
%     -.112448396800D+08  .305875000000D+01 -.125000000000D-03  .400000000000D+01
%      .799968000000D+05  .951600000000D+01 -.437500000000D-03  .000000000000D+00
% 20 00 01 13 14 51 12.0  .190921127796D-07 -.545696821064D-11  .534791280000D+05
%      .406135428800D+08  .153250000000D+01  .875000000000D-04  .000000000000D+00
%     -.112445465600D+08  .304687500000D+01 -.125000000000D-03  .400000000000D+01
%      .809084000000D+05  .947600000000D+01 -.437500000000D-03  .000000000000D+00
% 
% ----|---1|0---|---2|0---|---3|0---|---4|0---|---5|0---|---6|0---|---7|0---|---8|
% 
% 
