% field_of_current_filament.m
clear all; close all
r=0.2:0.2:1.2; phi=pi/10:pi/10:2*pi;
[R,PHI]=meshgrid(r,phi);
XX=R.*cos(PHI); YY=R.*sin(PHI);
B=1./(XX+i*YY);
By=real(B); Bx=imag(B);
quiver(XX,YY,Bx,By,'Color','r');
axis square; axis off; 
xlim([-1.2,1.2]); ylim([-1.2,1.2])
