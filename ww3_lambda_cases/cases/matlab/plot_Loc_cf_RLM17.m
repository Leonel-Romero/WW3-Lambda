clear all;close all
% This script loads Lambda(f,\theta) integrates it in azimuth
% and converts it to Lambda(c) and compares it to 
% Romero, Lenain, Melville 2017 (JPO) - RLM2017


% data path
pth='../RLM2017/';
% alternatively choose the example output path (U10=20 m/s)
%pth='../time_limited_runs/example/';

% set cases to compare
cases=dir([pth 'DIA*']);
file='ww3.2010_src.nc';


%% load Lambda(c) data and plot
load ../data/RLM2017_Lambdas

ax(1)=subplot(1,1,1);
axis_move_n_stretch(ax(1),.05,0,1,1);
pw=loglog(LAMBDA.C,LAMBDA.WARM_SIDE,...
    'Color',[ 1.0000   .6 .8],'LineWidth',1.5);%[ 1.0000    0.6000    0.7843]
hold on
pc=loglog(LAMBDA.C,LAMBDA.COLD_SIDE,'Color',....
     [  0    .6 1],'LineWidth',1.5)%[  0    0.7490    0.7490]
axis([1e-1 2e1 1e-7 1e-1])
set(gca,'YTick',10.^[-7:-1])

set(gca,'FontSize',14)
xlabel('$c$ (m/s)','interpreter','latex')
ylabel('$\Lambda$ (m$^{-2}$ s)','interpreter','latex')



ax(2)=axes('Position',[.3 .3 .3 .3]);% square inside
%axes('Position',[.65 .2 .3 .3]);% rectangular figure outside
box on

axes(ax(2))

pw=loglog(LAMBDA.C,LAMBDA.WARM_SIDE.*LAMBDA.C.^6,...
    'Color',[ 1.0000   .6 .8],'LineWidth',1.5);%[ 1.0000    0.6000    0.7843]
hold on
pc=loglog(LAMBDA.C,LAMBDA.COLD_SIDE.*LAMBDA.C.^6,'Color',....
    [  0    .6 1],'LineWidth',1.5)%[  0    0.7490    0.7490]
axis([1e0 2e1 3e-1 1e1])

set(gca,'XTick',[1 10])
set(gca,'FontSize',12)
xlabel('$c$','interpreter','latex')
ylabel('$\Lambda c^6$ (m$^4$ s$^{-5}$) ','interpreter','latex')


%%
n=1;
f=ncread([pth cases(n).name '/' file],'frequency');
d=ncread([pth cases(n).name '/' file],'direction')*pi/180;
dpt=ncread([pth cases(n).name '/' file],'dpt');
f2=ncread([pth cases(n).name '/' file],'frequency2');
f1=ncread([pth cases(n).name '/' file],'frequency1');
df=f2-f1;% df
dd=abs(median(diff(d)));% d \theta
g=9.81;% gravity
c=g./(2*pi*f);% phase speed
dfodc=2*pi.*f'.^2/g;%df/dc,  since in deep water c= g/(2 pi f)

% more generally:
%  h=dpt(1,1);
%  k=wavenumber_solver(2*pi*f,h);
%  c=2*pi.*f./k;
%  dfodc=((1/2/pi)*(1./k-4*h./(2*h*k+sinh(2*k*h))).^(-1))';%df/dc

for n=1:2
% Lambda(f,\theta,x,t) at all points and times
lof=ncread([pth cases(n).name '/' file],'lof');

%plot data first



%% selected time index to plot
nt=1;
cc='rb';
for nx=1:2
Lof2d=squeeze(lof(:,:,nx,nt));
% Integrate in azimuth L(f)=\sum(Lof2d  d\theta)
Lof1d=sum(Lof2d*dd);


axes(ax(1))
loglog(c,Lof1d.*dfodc,cc(nx),'LineWidth',.5*n^2)
hold on

axes(ax(2))
loglog(c,Lof1d.*dfodc.*c'.^6,cc(nx),'LineWidth',.5*n^2)

end
end

axes(ax(1))
loglog(c,c.^-6,'k--');
ll=legend('R17-W','R17-C','W','C','RW-W','RW-C','$c^{-6}$')
set(ll,'interpreter','latex')
axis_move_n_stretch(ll,0.02,0.04,1,1);

axes(ax(2))
c6=loglog(c,c.^0,'k--');
hold on

%ll=legend([pwm(1) pcm(1) pwm(2) pcm(2) pw pc c6],'W','C','RW-W','RW-C','R17-W','R17-C','$c^{-6}$')

fig = figure(1);
fig.PaperPositionMode = 'auto'
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3)*1. fig_pos(4)*1.]; % square
axis_move_n_stretch(ax(1),0.,0.025,1,1)
%fig.PaperSize = [fig_pos(3)*1 fig_pos(4)*1]; % rectangle
%axis_move_n_stretch(ax,0.,0.00,.5,1)
fname='Lambda_ww3_vs_RLM17';
eval(['print ./figures/' fname '.pdf -dpdf'])