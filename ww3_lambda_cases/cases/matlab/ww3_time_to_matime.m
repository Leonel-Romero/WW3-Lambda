function matime=ww3_time_to_matime(time)
%function matime=ww3_time_to_matime(time)
% L. Romero 2015


offset=datenum(1990,1,1);
matime=(time+offset);
