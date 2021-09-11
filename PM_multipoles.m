% PM_multipoles.m, V. Ziemann, 210910
clear all; close all
limit=0.5;  % limit drawing of arrows
Br=1.47;    % remanent field   [T]
w=10;       % width of the cube [mm]
o=18;       % outwards radial displacement of cube [mm]
MM=8;       % number of cubes
m=1;        % multipolarity (m=1: dipole, 2: quadrupole)

% scale=0.5;   %..scale size of cube
% w=scale*w;
% o=scale*o
% 
if exist('tmp/') ~= 7, mkdir('tmp'); end
fn=sprintf('tmp/MM%02d_m%1d_w%02d_o%02d',MM,m,w,o)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
cube=make_cubez(w,1,Br);
cubey=sheets_rotate_x(cube,-90);
for k=0:MM-1
  tmp=sheets_rotate_z(cubey,-k*m*360/MM);  % multiply angle by 2 -> quad
  tmp=sheets_translate(tmp,[o;0;0]);
  tmp=sheets_rotate_z(tmp,-k*360/MM);
  if k==0
    sheets=tmp;
  else
    sheets=[sheets;tmp];
  end
end

%sheets=sheets_rotate_z(sheets,5);  % rotate the whole package

hold on
for k=1:size(sheets,1)
  draw_sheets(sheets(k,:))
end

gridpoints=-w:w/5:w;
gx=gridpoints; gy=gx; gz=0;  % in xy-plane
field_from_sheets3(gx,gy,gz,sheets,limit)
axis equal
plot3([-w/2,w/2],[0,0],[0,0],'k:','LineWidth',2)
Nfft=256
r=w/2; phi=(0:360/Nfft:359)*pi/180;
line2=[r*cos(phi);r*sin(phi);0*ones(1,length(phi))];
plot3(line2(1,:),line2(2,:),line2(3,:),'c','LineWidth',2)
tg=1/sqrt(2); quiver3(r*tg,r*tg,0,-r*tg,r*tg,0,'c','Linewidth',2)
view(3)
set(gcf,'position',[1000,300,1000,800])
saveas(gcf,sprintf('%s_view',fn),'png')
toc
%return

figure  % By vs x
x=-w/2:w/100:w/2; y=0.0*ones(size(x)); z=0.0*ones(size(x));
line=[x;y;z];
Bline=field_along_line2(sheets,line);
plot(x,Bline(2,:),'k','LineWidth',2)
xlabel('x [mm]'); ylabel('B_y [T]')
xlim([-w/2,w/2]); %ylim([0.3,0.4])
set(gca,'FontSize',16)
saveas(gcf,sprintf('%s_By_vs_x',fn),'png')
dlmwrite(sprintf('%s_By_vs_x.dat',fn),[x',Bline(2,:)'],'\t')

figure % By vs z
z=-4*w:w/20:4*w; y=0.0*ones(size(z)); x=0.0*ones(size(z));
if (m==2) x=x+w/2+1e-6; end
line=[x;y;z];
Bline=field_along_line2(sheets,line);
if (m==2) 
  plot(z,1e3*Bline(2,:)*2/w,'k','LineWidth',2)
  ylabel('dB_y/dx [T/m]')
else
  plot(z,Bline(2,:),'k','LineWidth',2)
  ylabel('B_y [T]')
end
xlabel('z [mm]'); 
set(gca,'FontSize',16)
saveas(gcf,sprintf('%s_By_vs_z',fn),'png')
dlmwrite(sprintf('%s_By_vs_z.dat',fn),[z',Bline(2,:)'],'\t')

figure % B_t on a circle 
subplot(3,1,1)
Nfft=256;
r=w/2; phi=(0:360/Nfft:359)*pi/180;
line2=[r*cos(phi);r*sin(phi);0*ones(1,length(phi))];
tangent=[-sin(phi);cos(phi);0*ones(1,length(phi))];

Bline=field_along_line2(sheets,line2);
BB=dot(Bline,tangent);
plot(phi,BB,'k','LineWidth',2)
xlabel('\phi [rad]'); ylabel('B_t')
title('Field in the mid-plane')
set(gca,'FontSize',16)

subplot(3,1,2) % Multipolarity from FFT
trans=2*fft(BB)/Nfft;
bar(0:9,abs(trans(1:10)))
[Bmax,imax]=max(abs(trans(1:10)));
phi2=atan2(imag(trans(imax)),real(trans(imax)))*180/pi/(imax-1);
xlabel('Multipolarity m'); ylabel('B_m(r) [T]')
legend(['B_{max} = ' num2str(Bmax,3) ' T,  \phi = ' num2str(phi2,3) '^o']) 
set(gca,'FontSize',16)

subplot(3,1,3)  % relative magnitudes
rel=abs(trans(1:10))/Bmax;
%rel(1)=0; rel(2)=0; if (m==2) rel(3)=0; end
rel(1)=0; rel(m+1)=0;
bar(0:9,rel)
xlabel('Multipolarity m'); ylabel('B_m(r)/B_{max}')
ylim([0,1.2*max(rel)])
set(gca,'FontSize',16)
set(gcf,'position',[1100,200,1000,800])
saveas(gcf,sprintf('%s_midplane',fn),'png')
pause(0.02)

%return

figure % integrated field
subplot(3,1,1)
Bint=0*Bline;
zmin=-4*w-1e-6; zmax=4*w; dz=w/10;
for z=zmin:dz:zmax
  line2=[r*cos(phi);r*sin(phi);z*ones(1,length(phi))]; 
  Bline=field_along_line2(sheets,line2);
  Bint=Bint+Bline*dz;
end
toc
  
BB=dot(Bint,tangent);
plot(phi,BB,'k','LineWidth',2)
xlabel('\phi [rad]'); ylabel('\int B_t dz')
title('Integrated field')
set(gca,'FontSize',16)

subplot(3,1,2) % Multipolarity from FFT
trans=2*fft(BB)/Nfft;
bar(0:9,abs(trans(1:10)))
%bar(0:9,log10(1000*abs(trans(1:10))))
[Bmax,imax]=max(abs(trans(1:10)));
phi2=atan2(imag(trans(imax)),real(trans(imax)))*180/pi/(imax-1);
xlabel('Multipolarity m'); ylabel('\int B_m(r) [Tmm]')
legend(['\int B_{max} = ' num2str(Bmax,3) ' Tmm,  \phi = ' num2str(phi2,3) '^o']) 
set(gca,'FontSize',16)

subplot(3,1,3)  % relative magnitudes
rel=abs(trans(1:10))/Bmax; 
%rel(1)=0; rel(2)=0; if (m==2) rel(3)=0; end
rel(1)=0; rel(m+1)=0;
bar(0:9,rel)
xlabel('Multipolarity m'); ylabel('\int B_m(r)/\int B_{max}')
ylim([0,1.2*max(rel)]);
set(gca,'FontSize',16)
set(gcf,'position',[1200,100,1000,800])
saveas(gcf,sprintf('%s_integrated',fn),'png')
