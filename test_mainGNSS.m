function test_mainGNSS()

tic

%% Choosing data  
option = 22;

switch option
    case 1
        json_fn         =   'test_w_ephem.txt';
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
    case 8
        json_fn         =   '14032019_201643/14032019_201648.txt';
    case 9
        json_fn         =   'Logs_test_dia_15_3/15032019_115957/15032019_120002.txt';
    case 10
        json_fn         =   'Logs_test_dia_15_3/15032019_115957/15032019_120008.txt';
    case 11
        json_fn         =   'Logs_test_dia_15_3/15032019_115957/15032019_120014.txt';
    case 12
        json_fn         =   'Logs_test_dia_15_3/15032019_115957/15032019_120020.txt';
    case 13
        json_fn         =   'Logs_test_dia_15_3/15032019_115957/15032019_120026.txt';
    case 14
        json_fn         =   'Logs_test_dia_15_3/15032019_115957/15032019_120032.txt';
    case 15
        json_fn         =   'Logs_test_dia_15_3/15032019_115957/15032019_120038.txt';
    case 16
        json_fn         =   'Logs_test_dia_15_3/15032019_115957/15032019_120044.txt';   
    case 17
        json_fn         =   'Logs_test_dia_15_3/15032019_115957/15032019_120050.txt'; 
    case 18
        json_fn         =   'Logs_test_dia_15_3/15032019_115957/15032019_120056.txt'; 
    case 19
        json_fn         =   'Logs_test_dia_15_3/15032019_115957/15032019_120102.txt'; 
    case 20
        json_fn         =   'Logs_test_dia_15_3/15032019_115957/15032019_120108.txt'; 
    case 21
        json_fn         =   'Logs_test_dia_15_3/15032019_115957/15032019_120114.txt'; 
    case 22
        json_fn         =   'Logs_test_dia_15_3/15032019_115957/15032019_120120.txt'; 
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