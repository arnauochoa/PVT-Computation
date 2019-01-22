



% Analyze RINEX files in order to compute the PVT solution
%
clearvars;
close all;
clc;
fclose('all');
%
addpath 'Corrections';
addpath 'Corrections/Control_segment';
addpath 'Corrections/Prop_Effects';
addpath 'Ephemeris';
addpath 'Misc';
addpath 'Observations';
%
%
%


%-  Setting Parameters
%--     Navigation RINEX file


  NavFile     =   'BCLN00ESP_R_20182870000_01D.GN';


%--     Observation RINEX file


  ObsFile     = 'BCLN00ESP_R_20182870000_01D_30S_MO.00o' ;


%--     Satellite constellation to be used for the PVT computation
const       =   'GPS';              
%--     Number of epochs to be analyzed (max. 2880)
Nepoch      =  120 ;                
%--     Number of unknowns of the PVT solution
Nsol        =   4;                  
%--     Number of iterations used to obtain the PVT solution
Nit         =   6;                   
%--     Reference position (check RINEX file or website of the station)
PVTr        =  [4788065.1430   167551.1700  4196354.9920];
%--   Preliminary guess for PVT solution 
PVT0    =  [0 0 0 0]; 
PVT05= [4000000 700000  4000000];
PVT0L= [4000000 700000  4000000];

WPVT0 =  [4000000 700000  4000000];  %he puesto esta posicion inicial porque sino en la primera época el error es muy grande y no se ve bien los gráficos por la escala
% frecuencias GPS

L1= 1575.42e6;
L5= 1176.45e6;



%
%
%-  Initialization Parameters
%
%--     Get ephemerides and iono information from navigation message
[eph,iono]  =   getNavRINEX(NavFile);
%--     Open Observation RINEX file and take the header information
% TBD
%   Nobs:       # of observables (integer), check RINEX version
%   Obs_types:  List of observation types (string), check RINEX version
%   Rin_vers:   RINEX version (integer: 2 or 3)

fido=fopen(ObsFile);
[Nobs,Obs_types,year,Rin_vers]  =   anheader(fido);
% TBD
%
PVT_epoch         =   nan(Nepoch,Nsol);       %   PVT solution
GDOP        =   zeros(Nepoch,1);       %   Gdop
TOW         =   nan(Nepoch,1);          %   Time Of the Week (TOW)
%
%
%
%-  Sequentially read the Observation file and compute the PVT solutiond
% TBD

%establecer epocas en funcion de los tow.

for i= 1:Nepoch
   
 
 
 [pr,pr2,pr5,pL1,pL5,tow,sats]  =   getPR_epoch0(fido,year,Obs_types,Nobs,Rin_vers,const);


 Lsvn5(i)=length(find(pr5)); %numero de satelites L5 visibles por epoca (cuando pr5~=0)






%correccion ionosférica________________________

%correccion Pseudorango en L1 y L5.

[prIF,Im]= PR_ionoFree(L1,L5,pr,pr5);

Imm(i)= Im;
%______________________________________________


%cálculo de la PVT sin correcciones adicionales
[PVT,A,tcorr,Pcorr,ionoc]  =   PVT_recLS(pr,sats,tow,eph,iono,Nit,PVT0,1);

ionoc

PVT0=PVT;  %ojo! esto lo he tocado sin querer

PVT_epoch(i,:)=PVT;

G=inv(A.'*A);
g=diag(G);
GDOP(i)=sqrt(sum(g));
TOW(i)=tow;
RMS(i)=sqrt((PVT_epoch(i,1)-PVTr(1))^2+(PVT_epoch(i,2)-PVTr(2))^2+(PVT_epoch(i,3)-PVTr(3))^2);
SATS(i)=length(sats);

%PVT con correción ionosferica:

[PVT5,A5,tcorr5,Pcorr5]  =   WPVT_recLS(prIF,sats,tow,eph,iono,Nit,PVT05,1);
PVT05=PVT5;
PVT5_epoch(i,:)=PVT5;

RMS5(i)=sqrt((PVT5_epoch(i,1)-PVTr(1))^2+(PVT5_epoch(i,2)-PVTr(2))^2+(PVT5_epoch(i,3)-PVTr(3))^2);

%cálculo de la PVT con weighting:
[WPVT,WA,Wtcorr,WPcorr]  =   WPVT_recLS(pr,sats,tow,eph,iono,Nit,WPVT0,1);
WPVT0=WPVT;
WPVT_epoch(i,:)=WPVT;

WRMS(i)=sqrt((WPVT_epoch(i,1)-PVTr(1))^2+(WPVT_epoch(i,2)-PVTr(2))^2+(WPVT_epoch(i,3)-PVTr(3))^2);


RMSI = [RMS(i), WRMS(i), RMS5(i)];

% 
% con= min(RMSI);
% switch con
%     case RMS(i)
%         PVTtotal(i,:)= PVT;
%     case WRMS (i)
%         PVTtotal(i,:)= WPVT;
%     case RMS5 (i)
%         PVTtotal(i,:)= PVT5;
% end
% 

% 
% TRMS(i)=sqrt((PVTtotal(i,1)-PVTr(1))^2+(PVTtotal(i,2)-PVTr(2))^2+(PVTtotal(i,3)-PVTr(3))^2);
% 
end

figure
x=1:Nepoch;
stem(Imm)

% x=1:Nepoch;
% plot(TOW,RMS)
% title('RMS')
% xlabel('Time of the Week (s)');
% ylabel('Root Mean Square 3D error (m)');

% 
% figure
% 
% x=1:Nepoch;
% 
% plot(prcc)




%mostar el error que introduce la inosfera.


figure
x=1:Nepoch;
stem (Lsvn5)


%%
figure

x=1:Nepoch;


 plot(TOW,WRMS,'c') %weighted
 hold on
plot(TOW,RMS5,'b') %Weighted + ionofree
hold on
% plot(TOW,RMS,'g')  %sin correcciones
% hold on
% plot(TOW,TRMS,'r') %Aplicando o no ionofree para mejor RMS

title('RMS (WLS)')
xlabel('Time of the Week (s)');
ylabel('Root Mean Square 3D error (m)');




% figure
% plot(TOW,GDOP)
% title('GDOP')
% xlabel('Time of the Week (s)');
% ylabel('GDOP');

% figure
% plot(TOW,SATS)
% title('Number of satellites');
% xlabel('Time of the Week (s)');
% ylabel('Number of satellites');
% % 


    %--     Get the observed pseudoranges for all satellites in view of 
    %       a given constellation at the next epoch
    %
    %   pr:     Pseudoranges at given TOW for satellites in sats
    %           (Nsatx1)
    %   TOW:    Time Of the Week (TOW) of the next epoch    
    %   sats:   Satellites in view  
    %
    
    % TBD
    %
    %--     Compute the PVT solution at the next epoch
    % TBD
    %
 
    %--     Update the initial guess for the next epoch
   % TBD
   %

%
%
%-  Show results
%
% me      =   nanmean(PVT(:,1:3));
% mu_mov  =   movmean(PVT(:,1:3),[Nmov-1 0],1);
% spread      =   nanstd(PVT(:,1:3));
% err         =   []; % TBD
% err_mov     =   []; %TBD
% %
% fprintf('\nMean position as computed from %2.0f epochs:',Nepoch);
% fprintf('\n\nX: %12.3f  Y: %12.3f  Z: %12.3f\n', me(1), me(2), me(3));
% fprintf('\nstd (m) of each position coordinate:');
% fprintf('\nX: %2.2f Y: %2.2f Z:%2.2f\n',spread(1),spread(2),spread(3));
% %
% figure;plot(TOW,err);
% xlabel('Time of the Week (s)');
% ylabel('Root Mean Square 3D error (m)');



%-- CON PSEUDORANGO, TOW Y VELOCIDAD LUZ PODEMOS SACAR BIAS DEL CLOCK

