function X_sat_rot = e_r_corr(traveltime, X_sat)
% E_R_CORR  Returns rotated satellite ECEF coordinates
%           due to Earth rotation during signal travel time
    Omegae_dot  = 7.2921159e-5;           %  rad/sec
   omegatau     = Omegae_dot*traveltime;
   R3 = [  cos(omegatau) sin(omegatau) 0;
          -sin(omegatau) cos(omegatau) 0;
              0               0        1];
   X_sat_rot = R3*X_sat;

%%%%%%%% end e_r_corr.m %%%%%%%%%%%%%%%%%%%%%
