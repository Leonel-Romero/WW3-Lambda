function [Lfth,Sds2d,SDSCMN,WHITECAPDUR]=.....
    calculate_lambda_sds_f_offline(f,d,df,dd,efth,us,ww3_gridfile)
%function [Lfth,Sds2d,cmin,gamma]=calculate_lambda_sds_f_offline(f,d,df,dd,efth,us,ww3_gridfile)
% efth: frequency spectrum (m2 s/rad) 
% f   : frequency (Hz)
% d   : direction (rad)
% us  : friction velocity
%
% Lftht -- uses ww3 convention  L (per unt area)= \int Lfthk dk dtheta

g=9.81;

[F,D]=meshgrid(f,d);
[DF,D]=meshgrid(df,d);
C=g./(2*pi*F);% phase speed


[SDSL, SDSBBR,SDSBT,SDSA,SDSFACMTF,SPMSS,SDSNMTF,SDSMWD...
    ,SDSMWPOW,SDKOF,WHITECAPDUR,SDSCMN]=get_lambda_sds_params(ww3_gridfile);

ef=sum(efth*dd)';% 1d spectrum
Bfth=(2*pi)^4.*F.^5.*efth./2/g^2;% 2d saturaton
Bf=sum(Bfth*dd)';% 1d saturation


% MW
fofac=(SDKOF/28);
fo= g./us*fofac/(2*pi);%

%MTF
cmss=cumsum(2*Bf./f.*df);%cummulative mss;
% same as:cmss=cumsum((2*pi)^4/g^2*ef.*f.^4.*df);
dmeanlw=atan2(sum(efth(:).*sin(D(:)).*dd.*DF(:)),sum(efth(:).*cos(D(:)).*dd.*DF(:)));
[CMSS,D]=meshgrid(cmss,d); %1d to 2d matrix
CMSS1=CMSS.^SPMSS.*cos(D-dmeanlw).^2;% ww3 uses an ad-hoc way to determine
% the directon of the SDSBBRlonger waves
MTF1=(1+SDSFACMTF*CMSS1).^(SDSNMTF);

% b
[BB,D]=meshgrid(Bf,d);% 1d to 2d matrix
bb=SDSA*(max(0,sqrt(BB)-sqrt(SDSBT))).^(5/2);


Lfth=2*(2*pi)^2/g.*F.*SDSL.*exp(-SDSBBR./Bfth);% with the 1/K absorbed (care full in input Eok does not have it absored)
% add MTF
Lfth=Lfth.*MTF1;
% add MW
Lfth=Lfth.*(.5+.5*SDSMWD*max(1,(F./fo).^2).^SDSMWPOW)/(.5*(SDSMWD+1));%;
Lfth(find(Bfth(:)==0))=0;

Sds2d=bb./g^2.*(Lfth).*C.^5;
end


% MATLAB crashes when having this here and calling it multiple times
% function [ABT, Br, SDSBBR,SDSSTRAIN,SDSBCK,SDSCUM,WHITECAPWIDTH...
%     ,SDSC4,SDSLFGEN,SDSHFGEN,SDSC6,SDSBR2]=get_sds_params(fname);
% %function [ABT, Br, SDSBBR]=get_sds_params(fname);
% 
% %fname='./work_STX/ww3_grid.out';
% 
% 
% vars(1).name='SDSC2';%ABT;
% vars(2).name='SDSBR';%BR
% vars(3).name='SDSBRF1';%SDSBBR
% vars(4).name='SDSSTRAIN';%
% vars(5).name='SDSBCK';%
% vars(6).name='SDSCUM';%
% vars(7).name='WHITECAPWIDTH';%
% vars(8).name='SDSC4';%
% vars(9).name='SDSLFGEN';%
% vars(10).name='SDSHFGEN';%
% vars(11).name='SDSC6';%
% vars(12).name='SDSBR2';%
% 
% 
% for n=1:length(vars)
%   fid = fopen([fname],'r');   
%        
%     line=1;
% while line~=-1
% 
%     line=fgetl(fid);
%     a=strfind(line,[vars(n).name ' =']);
%     if ~isempty(a)
%         %disp(line);
%         head=line;
%  a=strfind(head,[vars(n).name ' =']);
%  i1=strfind(head(a:end),'=');
%  i2=strfind(head(a:end),',');
%  if isempty(i2)
%      i2=strfind(head(a:end),'/');
%  end
%  vars(n).val=str2num(head(a+i1:a+i2-2));
%         
%     end
%     if isempty(line);
%         line=1;
%     end
% end
% 
% % a=strfind(head,[vars(n).name ' =']);
% % vars(n).val=str2num(head(a+7:a+18));
% 
% 
% end
% 
% ABT=vars(1).val;
% Br=vars(2).val;
% SDSBBR=vars(3).val;
% SDSSTRAIN=vars(4).val;
% SDSBCK=vars(5).val;
% SDSCUM=vars(6).val;
% WHITECAPWIDTH=vars(7).val;
% SDSC4=vars(8).val;
% SDSLFGEN=vars(9).val;
% SDSHFGEN=vars(10).val;
% SDSC6=vars(11).val;
% SDSBR2=vars(12).val;
% 
% fclose(fid);
% fclose(all);
% end
