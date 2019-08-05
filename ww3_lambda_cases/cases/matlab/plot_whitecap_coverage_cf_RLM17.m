clear all;close all
% plot 2d map of whitecap coverage and compare with RLM2017

data_pth='../data/';
data='RLM2017_wcc';
load([data_pth data])

%ww3 data path
pth='../RLM2017/DIA_RWND/';

% ww3 file name
fname='ww3.201006.nc';

time=ncread([pth fname],'time');
matime=ww3_time_to_matime(time);
Lon=double(ncread([pth fname],'longitude')');

Lat=double(ncread([pth fname],'latitude')');

mask=double(ncread([pth fname],'MAPSTA')');
mask(mask(:)==0)=nan;
mask(mask(:)>0)=1;


[LO,LA]=meshgrid(Lon,Lat);

ind=1:length(matime);



    w3wcc=double(ncread([pth fname],'wcc',[1 1 ind(1)],[inf inf length(ind)]));
    w3uwnd=double(ncread([pth fname],'uwnd',[1 1 ind(1)],[inf inf length(ind)]));
    w3vwnd=double(ncread([pth fname],'vwnd',[1 1 ind(1)],[inf inf length(ind)]));
    w3uc=double(ncread([pth fname],'ucur',[1 1 ind(1)],[inf inf length(ind)]));
    w3vc=double(ncread([pth fname],'vcur',[1 1 ind(1)],[inf inf length(ind)]));
    w3wnd=abs(w3uwnd+i*w3vwnd);
      
%%

% Sampling time: Jun 18 00:00, 2010
nsync=find(matime==datenum(2010,6,18,0,0,0));

wccs=squeeze(w3wcc(:,:,nsync))';
Uc=squeeze(w3uc(:,:,nsync))';
Vc=squeeze(w3vc(:,:,nsync))';
U=squeeze(w3uwnd(:,:,nsync))';
V=squeeze(w3vwnd(:,:,nsync))';


[Ny,Nx]=size(LO);
nq=2;
inqx=1:nq:Nx;
inqy=1:nq:Ny;


%
figure
[c,h]=contourf(LO,LA,wccs*100,[.005:.0005:.016]*100);shading flat
hold on
cb=(jet(64));
colormap(cb)

qq=quiverthick_wdth1(LO(inqy,inqx),LA(inqy,inqx),Uc(inqy,inqx),...
    Vc(inqy,inqx),1,'w');%,....

qw=quiverthick_wdth1(-123.35,38.25,(nanmean(U(:))),(nanmean(V(:))),1/200,'k');

set(qq,'Linewidth',2,'Color',[.5 .5 .5])
set(qw,'Linewidth',2)

 scatter(lon(:),lat(:),500,wcc(:)*100,'.')
 plot(lon(:),lat(:),'wo','MarkerSize',6.5,'color',[.5 .5 .5],...
     'linewidth',.01)

axis([-123.41 -123.13 38.00   38.29])
set(gca,'FontSize',16)
caxis([.8 1.3])
set(h,'LineWidth',.001)
cc=colorbar;
xlabel('Longitude')
ylabel('Latitude')
cc.Label.String='$W$ (\%)';
cc.Label.Interpreter='latex';
cc.Ticks=[0.5:.1:1.5];
fig = gcf;
fig.PaperPositionMode = 'auto'
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3)*1 fig_pos(4)];

fname=['wcc_map_vs_RLM17'];
eval(['print ./figures/' fname '.pdf -dpdf'])


