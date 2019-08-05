clear all;close all
% This script loads Lambda(f,\theta) integrates it in azimuth
% and converts it to Lambda(c) for deep-water waves


% data path
pth='../time_limited_runs/';

% choose the DIA or WRT (for example)
cases=dir([pth 'DIA_*']);
file='ww3.1968_src.nc';
n=1 % select the file to be plotted

fname=[pth cases(n).name '/' file];

f=ncread(fname,'frequency');
d=ncread(fname,'direction')*pi/180;
dpt=ncread(fname,'dpt');
f2=ncread(fname,'frequency2');
f1=ncread(fname,'frequency1');
df=f2-f1;% df
dd=abs(median(diff(d)));% d \theta
g=9.81;% gravity
c=g./(2*pi*f);% phase speed
dfodc=2*pi.*f'.^2/g;%df/dc,  since in deep water c= g/(2 pi f)

% more generally:
% h=dpt(1,1);
% k=wavenumber_solver(2*pi*f,h);
% dfodc=(1/2/pi)*(1./k-4*h./(2*h*k+sinh(2*k*h))).^(-1);%df/dc


% selected time index to plot
nt=100;
% point
nx=1;

% L(\theta,f)
Lof2d=ncread(fname,'lof',[1 1 nx nt],[inf inf 1 1]);
% Integrate in azimuth L(f)=\sum(Lof2d  d\theta)
Lof1d=sum(Lof2d*dd);



figure
subplot(1,2,1)
loglog(f,Lof1d)
hold on
xlabel('f (Hz)')
ylabel('\Lambda(f) s/m')
axis([.05 1 1e-6 1e0])
subplot(1,2,2)
loglog(c,Lof1d.*dfodc)
hold on
loglog(c,5*c.^-6,'r')
xlabel('c (m/s)')
ylabel('\Lambda(c) m^-2 s')
axis([1 30 1e-8 1e0])