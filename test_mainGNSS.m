function test_mainGNSS()

option = 1;

switch option
    case 0
        json_fn         = 'example.txt';
    case 1
        json_fn         = 'in_pk.txt';
    case 2
        json_fn         = 'pk.txt';
end

    
%% Build struct from JSONs
json          = strcat('JSON/', json_fn);
json_content     = load_info(json);
[lat, long] = main_GNSS(json_content)



end