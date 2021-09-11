% PM_solenoid_radial.m, V. Ziemann, 210910
clear all; close all
limit=4;     % limit drawing of arrows
Br=1.47;     % remanent field
w=10;        % width of the cube
o=18;        % radial displacement of a cube
angle=0;     % rotation angle of one magnet versus the vertical
MM=8;        % number of cubes
m=0;         % multipolarity (m=1: dipole, 2: quadrupole)
spacing=50;   % space between the two magnets

if exist('tmp/') ~= 7, mkdir('tmp'); end
fn=sprintf('tmp/solrad_MM%02d_m%1d_w%02d_o%02d',MM,m,w,o)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
cube=make_cubez(w,1,Br);
cubey=sheets_rotate_y(cube,90);
for k=0:MM-1
  tmp=sheets_rotate_z(cubey,-k*m*360/MM);  % multiply angle by 2 -> quad
  tmp=sheets_translate(tmp,[o;0;0]);   % adjust for different m
  tmp=sheets_rotate_z(tmp,-k*360/MM);
  if k==0
    sheets=tmp;
  else
    sheets=[sheets;tmp];
  end
end
tmp1=sheets_translate(sheets,[0;0;-w/2-spacing/2]);

cubey=sheets_rotate_y(cube,-90);
for k=0:MM-1
  tmp=sheets_rotate_z(cubey,-k*m*360/MM);  % multiply angle by 2 -> quad
  tmp=sheets_translate(tmp,[o;0;0]);   % adjust for different m
  tmp=sheets_rotate_z(tmp,-k*360/MM);
  if k==0
    sheets=tmp;
  else
    sheets=[sheets;tmp];
  end
end
tmp2=sheets_translate(sheets,[0;0;w/2+spacing/2]);

sheets=[tmp1;tmp2];

hold on
for k=1:size(sheets,1)
  draw_sheets(sheets(k,:))
end
axis equal
view(3)
set(gcf,'position',[1000,100,800,1200])

gridpoints=-w:w/5:w;
gx=gridpoints; gy=gx; gz=0;  % in xy-plane
field_from_sheets3(gx,gy,gz,sheets,limit)
axis equal
plot3([-w/2,w/2],[0,0],[0,0],'k:','LineWidth',2)
Nfft=256;
r=w/2; phi=(0:360/Nfft:359)*pi/180;
line2=[r*cos(phi);r*sin(phi);0*ones(1,length(phi))];
plot3(line2(1,:),line2(2,:),line2(3,:),'c','LineWidth',2)
tg=1/sqrt(2); quiver3(r*tg,r*tg,0,-r*tg,r*tg,0,'c','Linewidth',2)
view(10,35)
set(gcf,'position',[1000,300,1000,800])
saveas(gcf,sprintf('%s_view',fn),'png')
toc

figure  % side view 
hold on
for k=1:size(sheets,1)
  draw_sheets(sheets(k,:))
end
gx=-40:5:40; gy=0; gz=-40:5:40;  % in xz-plane
field_from_sheets2D(gx,gz,sheets,0.5)
axis equal
plot3([-w/2,w/2],[0,0],[0,0],'k:','LineWidth',2)
Nfft=256;
r=w/2; phi=(0:360/Nfft:359)*pi/180;
line2=[r*cos(phi);r*sin(phi);0*ones(1,length(phi))];
plot3(line2(1,:),line2(2,:),line2(3,:),'c','LineWidth',2)
%tg=1/sqrt(2); quiver3(r*tg,r*tg,0,-r*tg,r*tg,0,'c','Linewidth',2)
zlim([-40,40]); xlim([-40,40])
view(-27,12)
set(gcf,'position',[1000,300,1000,800])
saveas(gcf,sprintf('%s_view2',fn),'png')

figure  % Bz vs x
x=-w/2:w/100:w/2; y=0.0*ones(size(x)); z=0.0*ones(size(x));
line=[x;y;z];
Bline=field_along_line2(sheets,line);
plot(x,Bline(3,:),'k','LineWidth',2)
xlabel('x [mm]'); ylabel('B_z [T]')
xlim([-3,3]); %ylim([0.3,0.4])
set(gca,'FontSize',16)
saveas(gcf,sprintf('%s_Bz_vs_x',fn),'png')
dlmwrite(sprintf('%s_Bz_vs_x.dat',fn),[x',Bline(2,:)'],'\t')

figure % Bz vs z
z=-6*w:w/10:6*w; y=0.0*ones(size(z)); x=0.0*ones(size(z));
%z=-100:w/10:400; y=0.0*ones(size(z)); x=0.0*ones(size(z));
line=[x;y;z];
Bline=field_along_line2(sheets,line);
plot(z,Bline(3,:),'k','LineWidth',2)
% 
% hold on; 
% plot([-10,-10,-20,-20,-10],[-0.2,0.13,0.13,-0.2,-0.2],'b--')
% plot([10,10,20,20,10],[-0.2,0.13,0.13,-0.2,-0.2],'b--')
% ylim([-0.25,0.16])
%
xlabel('z [mm]'); ylabel('B_z [T]')
Bmax=max(Bline(3,:));
%xlim([-5,5]); %ylim([0.98*Bmax,1.02*Bmax]);
set(gca,'FontSize',16)
saveas(gcf,sprintf('%s_Bz_vs_z',fn),'png')
dlmwrite(sprintf('%s_Bz_vs_z.dat',fn),[z',Bline(3,:)'],'\t')

%return

figure % B_t on a circle 
subplot(3,1,1)
Nfft=256;
r=w/2; phi=(0:360/(Nfft):359)*pi/180;
line2=[r*cos(phi);r*sin(phi);0*ones(1,length(phi))];
tangent=[-sin(phi);cos(phi);0*ones(1,length(phi))];

Bline=field_along_line2(sheets,line2);
%BB=dot(Bline,tangent);
BB=Bline(3,:);
plot(phi,BB,'k','LineWidth',2)
xlabel('\phi [rad]'); ylabel('B_t')
title('Field in the mid-plane')
set(gca,'FontSize',16)

subplot(3,1,2) % Multipolarity from FFT
trans=2*fft(BB)/Nfft; trans(1)=0.5*trans(1);
bar(0:9,abs(trans(1:10)))
[Bmax,imax]=max(abs(trans(1:10)));
%if (imax==1) Bmax=0.5*Bmax; end  % DC harmonic only counts half
phi2=atan2(imag(trans(imax)),real(trans(imax)))*180/pi/(imax-1);
xlabel('Multipolarity m'); ylabel('B_m(r) [T]')
legend(['B_{max} = ' num2str(Bmax,3) ' T,  \phi = ' num2str(phi2,3) '^o']) 
set(gca,'FontSize',16)

subplot(3,1,3)  % relative magnitudes
rel=abs(trans(1:10))/Bmax; 
rel(1)=0; rel(m+1)=0;
bar(0:9,rel)
xlabel('Multipolarity m'); ylabel('B_m(r)/B_{max}')
ylim([0,1.2*max(rel)])
set(gca,'FontSize',16)
set(gcf,'position',[1100,200,1000,800])
saveas(gcf,sprintf('%s_midplane',fn),'png')
pause(0.02)

