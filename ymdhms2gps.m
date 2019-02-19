function outmat = ymdhms2gps(year,month,mday,hour,minute,second)

days_per_second = 0.00001157407407407407;
jan680=44244;
mjd_jan1_1901 = 15385;
month_day=[0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334;
0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335];


leap = (mod(year,4) == 0);  
days_from_jan1 =  month_day(leap+1,month) + mday -1;
years_into_election = mod(year-1,4);
elections = floor((year - 1901)/4);
mjday = mjd_jan1_1901 + elections*1461 + years_into_election*365 + days_from_jan1;
fmjd = ( hour*3600 + minute*60 + second)*days_per_second;
idays = mjday - jan680;
pgpswk = floor(idays/7);
dayofwk = idays - (pgpswk)*7;
psecofwk = (dayofwk + fmjd)*86400;

outmat(1)=pgpswk;
outmat(2)=psecofwk;