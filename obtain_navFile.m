function navFile = obtain_navFile(time)


%% Filename build

GDC_server      = 'igs.bkg.bund.de/';

% RINEX station
%rinex_station = 'bcln'; % How to make this dynamic?
rinex_station = 'gaia'; %for nav v3.0

% Timestamp info
[doy, year4] = nsgpst2doyyear4(time);

% Normalization of doy length
while length(doy) < 3
    doy = strcat('0', num2str(doy));
end

% Converting year to two digits
if year4 < 2000
    year = num2str(year4 - 1900);
else
    year = num2str(year4 - 2000);
end
    
navtype = 'n'; %how to modify this? download all directly?
% navtype = 'g';
% navtype = 'd';

% Filename
nav_fn      = strcat(rinex_station, doy, '0.', year, navtype);
navFile     = strcat('RINEX/nav/', nav_fn);

%% File download
% v2
navURL = strcat('ftp://', GDC_server, '/EUREF/obs_v3/', num2str(year4), '/', doy, '/', nav_fn, '.Z');
% v3 (too few stations)
%navURL = strcat('ftp://', GDC_server, '/EUREF/obs_3/', num2str(year4), '/', doy, '/', nav_fn, '.Z');

urlwrite(navURL, strcat(navFile, '.Z'));

%urlwrite(navURL, strcat('RINEX/nav/', year4, doy, nav_fn, '.Z'));
% Need to solve the folder issue

%% Does not work; don't know why
% ftpClient                       =   ftp(GDC_server);
% ftpFiles                        =   dir(ftpClient, strcat('/EUREF/obs/', year4, '/', doy, '/'));


end