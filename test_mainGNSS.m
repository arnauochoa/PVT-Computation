function test_mainGNSS()

option = 3;

switch option
    case 0
        json_fn         = 'example.txt'; % not enough satellites for anything
    case 1
        json_fn         = 'in_pk.txt';
    case 2
        json_fn         = 'pk.txt';
    case 3
        json_fn         = 'test_w_ephem.txt';
    case 4
        json_fn         = 'JSON_modificado.rnx';
end

    
%% Build str from JSON
json            = strcat('JSON/', json_fn);
json_content    = load_info(json);

%% Execution

flags.GPS       =   1;
flags.Galileo   =   0;
flags.GLONASS   =   0;
flags.QZSS      =   0;
flags.UNK       =   0;
flags.BEIDOU    =   0;
flags.SBAS      =   0;

flags.LS        =   1;
flags.WLS       =   0;
flags.Kalman    =   0;

[lat, long] = main_GNSS(json_content);
fprintf('\nCopy to Google:');
fprintf('\n%f, %f\n', lat, long);



end