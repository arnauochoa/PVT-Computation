function test_mainGNSS()

tic

%% Choosing data  
option = 5;

switch option
    case 1
        json_fn         =   'test_w_ephem.txt'; % GPS + Galileo ok
    case 2
        json_fn         =   '280219_1432.rnx';
    case 3
        json_fn         =   '280219_1434.rnx';
    case 4
        json_fn         =   '280219_1435.rnx';
    case 5
        json_fn         =   '280219_1440.rnx';
    case 6
        json_fn         =   '050319_1000.rnx';
    case 7
        json_fn         =   '050319_1001.rnx';
end

%% Build str from JSON
json            = strcat('JSON/', json_fn);
json_content    = load_info(json);

%% Execution
[lat, long] = main_GNSS(json_content);
fprintf('\nCopy to Google:');
fprintf('\n%f, %f\n\n', lat, long);

toc

end