function [SDSL, SDSBBR,SDSBT,SDSA,SDSFACMTF,SPMSS,SDSNMTF,SDSMWD...
    ,SDSMWPOW,SDKOF,WHITECAPDUR,SDSCMN]=get_lambda_sds_params(fname);
%function [SDSL, SDSBBR,SDSBT,SDSA,SDSFACMTF,SPMSS,SDSNMTF,SDSMWD...
%    ,SDSMWPOW,SDKOF,WHITECAPDUR,SDSCMN]=get_lambda_sds_params(fname);


vars(1).name='SDSL';%l;
vars(2).name='SDSBBR';%B_{BR}

vars(3).name='SDSBT';%B_T
vars(4).name='SDSA ';% A

vars(5).name='SDSFACMTF';%
vars(6).name='SPMSS';% cmss (power.)
vars(7).name='SDSNMTF';% MTF power

vars(8).name='SDSMWD';% D
vars(9).name='SDSMWPOW';% MW power
vars(10).name='SDKOF';% ko factor

vars(11).name='WHITECAPDUR';% gamma
vars(12).name='SDSCMN';% cmin for whitecap coverage and VA


for n=1:length(vars)
  fid = fopen([fname],'r');   
    line=1;
while line~=-1

    line=fgetl(fid);
  %  a=strfind(line,[vars(n).name ' =']);
  a=strfind(line,[vars(n).name]);
  eq=strfind(line,'=');
    if ~isempty(a) & ~isempty(eq)
        %disp(line);%get_lambda_sds_params
        head=line;
 a=strfind(head,[vars(n).name]);
 i1=strfind(head(a:end),'=');
 i2=strfind(head(a:end),',');
 if isempty(i2)
     i2=strfind(head(a:end),'/');
 end
 vars(n).val=str2num(head(a+i1:a+i2-2));
        
    end
    if isempty(line);
        line=1;
    end
end

% a=strfind(head,[vars(n).name ' =']);
% vars(n).val=str2num(head(a+7:a+18));


end

SDSL=vars(1).val;
SDSBBR=vars(2).val;

SDSBT=vars(3).val;
SDSA=vars(4).val;

SDSFACMTF=vars(5).val;
SPMSS=vars(6).val;
SDSNMTF=vars(7).val;

SDSMWD=vars(8).val;
SDSMWPOW=vars(9).val;
SDKOF=vars(10).val;

WHITECAPDUR=vars(11).val;
SDSCMN=vars(12).val;

fclose(fid);
fclose('all');
