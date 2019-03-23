function test_mainGNSS()

tic

%% Choosing data  

option  =    1;

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
    case 9 % every 5s
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
    case 23 % every 10s
        json_fn         =   'Logs_test_dia_15_3/15032019_120123/15032019_120133.txt'; 
    case 24
        json_fn         =   'Logs_test_dia_15_3/15032019_120123/15032019_120144.txt'; 
    case 25
        json_fn         =   'Logs_test_dia_15_3/15032019_120123/15032019_120155.txt'; 
    case 26
        json_fn         =   'Logs_test_dia_15_3/15032019_120123/15032019_120206.txt'; 
    case 27
        json_fn         =   'Logs_test_dia_15_3/15032019_120123/15032019_120217.txt'; 
    case 28
        json_fn         =   'Logs_test_dia_15_3/15032019_120123/15032019_120228.txt'; 
    case 29
        json_fn         =   'Logs_test_dia_15_3/15032019_120123/15032019_120239.txt'; 
    case 30 % every 20s
        json_fn         =   'Logs_test_dia_15_3/15032019_120244/15032019_120304.txt'; 
    case 31
        json_fn         =   'Logs_test_dia_15_3/15032019_120244/15032019_120325.txt'; 
    case 32
        json_fn         =   'Logs_test_dia_15_3/15032019_120244/15032019_120346.txt'; 
    case 33
        json_fn         =   'Logs_test_dia_15_3/15032019_120244/15032019_120407.txt'; 
    case 34 % Q5 every 5s
        json_fn         =   'Logs_test_dia_15_3/15032019_121357/15032019_121402.txt';
    case 35
        json_fn         =   'Logs_test_dia_15_3/15032019_121357/15032019_121408.txt';
    case 36
        json_fn         =   'Logs_test_dia_15_3/15032019_121357/15032019_121414.txt';
    case 37
        json_fn         =   'Logs_test_dia_15_3/15032019_121357/15032019_121420.txt';
    case 38
        json_fn         =   'Logs_test_dia_15_3/15032019_121357/15032019_121426.txt';
    case 39
        json_fn         =   'Logs_test_dia_15_3/15032019_121357/15032019_121432.txt';
    case 40
        json_fn         =   'Logs_test_dia_15_3/15032019_121357/15032019_121438.txt';
    case 41
        json_fn         =   'Logs_test_dia_15_3/15032019_121357/15032019_121444.txt';
    case 42
        json_fn         =   'Logs_test_dia_15_3/15032019_121357/15032019_121450.txt';
    case 43
        json_fn         =   'Logs_test_dia_15_3/15032019_121357/15032019_121456.txt';
    case 44
        json_fn         =   'Logs_test_dia_15_3/15032019_121357/15032019_121502.txt';
    case 45
        json_fn         =   'Logs_test_dia_15_3/15032019_121357/15032019_121508.txt';
    case 46
        json_fn         =   'Logs_test_dia_15_3/15032019_121357/15032019_121514.txt';
    case 47
        json_fn         =   'Logs_test_dia_15_3/15032019_121357/15032019_121520.txt';
    case 48
        json_fn         =   'Logs_test_dia_15_3/15032019_121357/15032019_121526.txt';
    case 49
        json_fn         =   'Logs_test_dia_15_3/15032019_121357/15032019_121532.txt';
    case 50
        json_fn         =   'Logs_test_dia_15_3/15032019_121357/15032019_121538.txt';
    case 51
        json_fn         =   'Logs_test_dia_15_3/15032019_121357/15032019_121544.txt';
    case 52
        json_fn         =   'Logs_test_dia_15_3/15032019_121357/15032019_121550.txt';
    case 53
        json_fn         =   'Logs_test_dia_15_3/15032019_121357/15032019_121556.txt';
    case 54
        json_fn         =   'Logs_test_dia_15_3/15032019_121357/15032019_121602.txt';
    case 55
        json_fn         =   'Logs_test_dia_15_3/15032019_121357/15032019_121608.txt';
    case 56
        json_fn         =   'Logs_test_dia_15_3/15032019_121357/15032019_121614.txt';
    case 57
        json_fn         =   'Logs_test_dia_15_3/15032019_121357/15032019_121620.txt';
    case 58
        json_fn         =   'Logs_test_dia_15_3/15032019_121357/15032019_121626.txt';
    case 59
        json_fn         =   'Logs_test_dia_15_3/15032019_121357/15032019_121632.txt';
    case 60
        json_fn         =   'Logs_test_dia_15_3/15032019_121357/15032019_121638.txt';
    case 61 % Q5 every 10s
        json_fn         =   'Logs_test_dia_15_3/15032019_121644/15032019_121655.txt';
    case 62 
        json_fn         =   'Logs_test_dia_15_3/15032019_121644/15032019_121706.txt';
    case 63 
        json_fn         =   'Logs_test_dia_15_3/15032019_121644/15032019_121717.txt';
    case 64 
        json_fn         =   'Logs_test_dia_15_3/15032019_121644/15032019_121728.txt';
    case 65 
        json_fn         =   'Logs_test_dia_15_3/15032019_121644/15032019_121739.txt';
    case 66 
        json_fn         =   'Logs_test_dia_15_3/15032019_121644/15032019_121750.txt';
    case 67 
        json_fn         =   'Logs_test_dia_15_3/15032019_121644/15032019_121801.txt';
    case 68 
        json_fn         =   'Logs_test_dia_15_3/15032019_121644/15032019_121812.txt';
    case 69 
        json_fn         =   'Logs_test_dia_15_3/15032019_121644/15032019_121823.txt';
    case 70 
        json_fn         =   'Logs_test_dia_15_3/15032019_121644/15032019_121834.txt';
    case 71 
        json_fn         =   'Logs_test_dia_15_3/15032019_121644/15032019_121845.txt';
    case 72 
        json_fn         =   'Logs_test_dia_15_3/15032019_121644/15032019_121856.txt';
    case 73 
        json_fn         =   'Logs_test_dia_15_3/15032019_121644/15032019_121907.txt';
    case 74 
        json_fn         =   'Logs_test_dia_15_3/15032019_121644/15032019_121918.txt';
    case 75 % Q5 every 20s 
        json_fn         =   'Logs_test_dia_15_3/15032019_121919/15032019_121940.txt';
    case 76 
        json_fn         =   'Logs_test_dia_15_3/15032019_121919/15032019_122001.txt';
    case 77 
        json_fn         =   'Logs_test_dia_15_3/15032019_121919/15032019_122022.txt';
    case 78 
        json_fn         =   'Logs_test_dia_15_3/15032019_121919/15032019_122043.txt';
    case 79 
        json_fn         =   'Logs_test_dia_15_3/15032019_121919/15032019_122104.txt';
    case 80 
        json_fn         =   'Logs_test_dia_15_3/15032019_121919/15032019_122125.txt';
    case 81 
        json_fn         =   'Logs_test_dia_15_3/15032019_121919/15032019_122146.txt';
    case 82 % along firefig parking
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123103.txt';
    case 83
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123109.txt';
    case 84
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123114.txt';
    case 85
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123120.txt';
    case 86
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123126.txt';
    case 87
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123132.txt';
    case 88
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123138.txt';
    case 89
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123144.txt';
    case 90
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123150.txt';
    case 91
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123156.txt';
    case 92
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123202.txt';
    case 93
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123208.txt';
    case 94
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123214.txt';
    case 95
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123220.txt';
    case 96
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123226.txt';
    case 97
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123232.txt';
    case 98
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123238.txt';
    case 99
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123244.txt';
    case 100
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123250.txt';
    case 101
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123256.txt';
    case 102
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123302.txt';
    case 103
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123308.txt';
    case 104
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123314.txt';
    case 105
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123320.txt';
    case 106
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123326.txt';
    case 107
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123332.txt';
    case 108
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123338.txt';
    case 109
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123344.txt';
    case 110
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123350.txt';
    case 111
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123356.txt';
    case 112
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123402.txt';
    case 113
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123408.txt';
    case 114
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123414.txt';
    case 115
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123420.txt';
    case 116
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123426.txt';
    case 117
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123432.txt';
    case 118
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123437.txt';
    case 119
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123443.txt';
    case 120
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123449.txt';
    case 121
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123455.txt';
    case 122
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123501.txt';
    case 123
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123506.txt';
    case 124
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123512.txt';
    case 125
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123518.txt';
    case 126
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123524.txt';
    case 127
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123530.txt';
    case 128
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123536.txt';
    case 129
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123542.txt';
    case 130
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123548.txt';
    case 131
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123554.txt';
    case 132
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123600.txt';
    case 133
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123606.txt';
    case 134
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123611.txt';
    case 135
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123617.txt';
    case 136
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123623.txt';
    case 137
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123629.txt';
    case 138
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123635.txt';
    case 139
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123641.txt';
    case 140
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123647.txt';
    case 141
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123653.txt';
    case 142
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123659.txt';
    case 143
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123705.txt';
    case 144
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123711.txt';
    case 145
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123717.txt';
    case 146
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123723.txt';
    case 147
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123729.txt';
    case 148
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123735.txt';
    case 149
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123741.txt';
    case 150
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123747.txt';
    case 151
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123753.txt';
    case 152
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123759.txt';
    case 153
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123805.txt';
    case 154
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123811.txt';
    case 155
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123817.txt';
    case 156
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123823.txt';
    case 157
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123829.txt';
    case 158
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123835.txt';
    case 159
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123841.txt';
    case 160
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123847.txt';
    case 161
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123853.txt';
    case 162
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123859.txt';
    case 163
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123905.txt';
    case 164
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123911.txt';
    case 165
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123917.txt';
    case 166
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123923.txt';
    case 167
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123929.txt';
    case 168
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123935.txt';
    case 169
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123941.txt';
    case 170
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123947.txt';
    case 171
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123953.txt';
    case 172
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_123959.txt';
    case 173
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_124004.txt';
    case 174
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_124010.txt';
    case 175
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_124016.txt';
    case 176
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_124022.txt';
    case 177
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_124028.txt';
    case 178
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_124034.txt';
    case 179
        json_fn         =   'Logs_test_dia_15_3/15032019_123058/15032019_124040.txt';
    case 180 % firefight to caf
        json_fn         =   'Logs_test_dia_15_3/15032019_124145/15032019_124150.txt';
    case 181 
        json_fn         =   'Logs_test_dia_15_3/15032019_124145/15032019_124156.txt';
    case 182 
        json_fn         =   'Logs_test_dia_15_3/15032019_124145/15032019_124202.txt';
    case 183 
        json_fn         =   'Logs_test_dia_15_3/15032019_124145/15032019_124208.txt';
    case 184 
        json_fn         =   'Logs_test_dia_15_3/15032019_124145/15032019_124214.txt';
    case 185 
        json_fn         =   'Logs_test_dia_15_3/15032019_124145/15032019_124220.txt';
    case 186 
        json_fn         =   'Logs_test_dia_15_3/15032019_124145/15032019_124226.txt';
    case 187 
        json_fn         =   'Logs_test_dia_15_3/15032019_124145/15032019_124232.txt';
    case 188 
        json_fn         =   'Logs_test_dia_15_3/15032019_124145/15032019_124238.txt';
    case 189 
        json_fn         =   'Logs_test_dia_15_3/15032019_124145/15032019_124244.txt';
    case 190 
        json_fn         =   'Logs_test_dia_15_3/15032019_124145/15032019_124250.txt';
    case 191 
        json_fn         =   'Logs_test_dia_15_3/15032019_124145/15032019_124256.txt';
    case 192 
        json_fn         =   'Logs_test_dia_15_3/15032019_124145/15032019_124302.txt';
    case 193 
        json_fn         =   'Logs_test_dia_15_3/15032019_124145/15032019_124308.txt';
    case 194 
        json_fn         =   'Logs_test_dia_15_3/15032019_124145/15032019_124314.txt';
    case 195 
        json_fn         =   'Logs_test_dia_15_3/15032019_124145/15032019_124320.txt';
    case 196 
        json_fn         =   'Logs_test_dia_15_3/15032019_124145/15032019_124326.txt';
    case 197 
        json_fn         =   'Logs_test_dia_15_3/15032019_124145/15032019_124332.txt';
    case 198 
        json_fn         =   'Logs_test_dia_15_3/15032019_124145/15032019_124338.txt';
    case 199 
        json_fn         =   'Logs_test_dia_15_3/15032019_124145/15032019_124344.txt';
    case 200 
        json_fn         =   'Logs_test_dia_15_3/15032019_124145/15032019_124350.txt';
    case 201 
        json_fn         =   'Logs_test_dia_15_3/15032019_124145/15032019_124356.txt';
    case 202 
        json_fn         =   'Logs_test_dia_15_3/15032019_124145/15032019_124402.txt';
    case 203 
        json_fn         =   'Logs_test_dia_15_3/15032019_124145/15032019_124408.txt';
    case 204 
        json_fn         =   'Logs_test_dia_15_3/15032019_124145/15032019_124414.txt';
    case 205 
        json_fn         =   'Logs_test_dia_15_3/15032019_124145/15032019_124420.txt';
    case 206 
        json_fn         =   'Logs_test_dia_15_3/15032019_124145/15032019_124426.txt';
    case 207 % car 
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124702.txt';
    case 208
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124708.txt';
    case 209
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124713.txt';
    case 210
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124719.txt';
    case 211
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124725.txt';
    case 212
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124731.txt';
    case 213
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124737.txt';
    case 214
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124743.txt';
    case 215
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124749.txt';
    case 216
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124755.txt';
    case 217
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124801.txt';
    case 218
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124807.txt';
    case 219
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124813.txt';
    case 220
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124819.txt';
    case 221
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124825.txt';
    case 222
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124831.txt';
    case 223
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124837.txt';
    case 224
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124843.txt';
    case 225
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124849.txt';
    case 226
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124855.txt';
    case 227
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124901.txt';
    case 228
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124907.txt';
    case 229
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124913.txt';
    case 230
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124919.txt';
    case 231
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124925.txt';
    case 232
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124931.txt';
    case 233
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124937.txt';
    case 234
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124943.txt';
    case 235
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124949.txt';
    case 236
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_124955.txt';
    case 237
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125001.txt';
    case 238
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125007.txt';
    case 239
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125013.txt';
    case 240
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125019.txt';
    case 241
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125025.txt';
    case 242
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125031.txt';
    case 243
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125037.txt';
    case 244
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125043.txt';
    case 245
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125049.txt';
    case 246
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125055.txt';
    case 247
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125101.txt';
    case 248
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125107.txt';
    case 249
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125113.txt';
    case 250
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125119.txt';
    case 251
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125125.txt';
    case 252
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125131.txt';
    case 253
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125137.txt';
    case 254
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125143.txt';
    case 255
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125149.txt';
    case 256
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125155.txt';
    case 257
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125201.txt';
    case 258
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125207.txt';
    case 259
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125213.txt';
    case 259
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125219.txt';
    case 260
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125225.txt';
    case 261
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125231.txt';
    case 262
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125237.txt';
    case 263
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125243.txt';
    case 264
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125249.txt';
    case 265
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125255.txt';
    case 266
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125301.txt';
    case 267
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125307.txt';
    case 268
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125313.txt';
    case 269
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125319.txt';
    case 270
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125325.txt';
    case 271
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125331.txt';
    case 272
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125337.txt';
    case 273
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125343.txt';
    case 274
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125349.txt';
    case 275
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125355.txt';
    case 276
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125401.txt';
    case 277
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125407.txt';
    case 278
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125413.txt';
    case 279
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125419.txt';
    case 280
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125425.txt';
    case 281
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125431.txt';
    case 282
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125437.txt';
    case 283
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125443.txt';
    case 284
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125449.txt';
    case 285
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125455.txt';
    case 286
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125501.txt';
    case 287
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125507.txt';
    case 288
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125513.txt';
    case 289
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125519.txt';
    case 290
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125525.txt';
    case 291
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125531.txt';
    case 292
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125537.txt';
    case 293
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125543.txt';
    case 294
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125549.txt';
    case 295
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125555.txt';
    case 296
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125601.txt';
    case 297
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125607.txt';
    case 298
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125613.txt';
    case 299
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125619.txt';
    case 300
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125625.txt';
    case 301
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125631.txt';
    case 301
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125637.txt';
    case 302
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125643.txt';
    case 303
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125649.txt';
    case 304
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125655.txt';
    case 305
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125701.txt';
    case 306
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125707.txt';
    case 307
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125713.txt';
    case 308
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125719.txt';
    case 309
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125725.txt';
    case 310
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125731.txt';
    case 311
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125737.txt';
    case 312
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125743.txt';
    case 313
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125749.txt';
    case 314
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125755.txt';
    case 315
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125801.txt';
    case 316
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125807.txt';
    case 317
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125813.txt';
    case 318
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125819.txt';
    case 319
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125826.txt';
    case 320
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125832.txt';
    case 321
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125838.txt';
    case 322
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125844.txt';
    case 323
        json_fn         =   'Logs_test_dia_15_3/15032019_124656/15032019_125850.txt';
    case 324
        json_fn         =   '21032019_123623/21032019_123629.txt';
    case 325
        json_fn         =   '21032019_123623/21032019_123635.txt';
    case 326
        json_fn         =   '21032019_123623/21032019_123641.txt';
    case 327
        json_fn         =   '21032019_131340/21032019_131447.txt';
    case 328
        json_fn         =   '21032019_131340/21032019_131417.txt';
    case 329
        json_fn         =   '21032019_131340/21032019_131447.txt';
    case 330
        json_fn         =   '21032019_131340/21032019_131509.txt';
    case 331
        json_fn         =   '21032019_131340/21032019_131631.txt';
    case 332
        json_fn         =   '21032019_131340/21032019_131615.txt';
    case 333
        json_fn         =   '21032019_131340/21032019_131709.txt';
    case 334
        json_fn         =   '21032019_131340/21032019_131345.txt';
    case 335
        json_fn         =   '21032019_131340/21032019_131648.txt';

end

%% Build str from JSON
json            = strcat('JSON/', json_fn);
json_content    = load_info(json);
%% Execution
[results, H, test] = main_GNSS(json_content);

for i=1:size(results, 1)
    p_err           =   sqrt((test(1:3) - lla2ecef(results(i, 1:3))).^2);
    fprintf('\n(Averaged) computed position and time for configuration %G\n', i);
    fprintf('Latitude: %f Longitude: %f Height: %f Time: %f\n', results(i, 1), results(i, 2), results(i, 3), results(i, 4));
    fprintf(strcat('2D error: %f m\n'), sqrt((p_err(1))^2 + (p_err(2))^2));
end

% for i=1:size(results, 1)   
%     fprintf('Configuration %G. Copy to Google:\n', i);
%     fprintf('%f, %f\n\n', results(i, 1), results(i, 2));
% end

toc

end