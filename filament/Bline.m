% Bline.m
function out=Bline(I,ra,rb,r2)
A=dot(r2-ra,r2-ra);
B=dot(r2-ra,rb-ra);
C=dot(rb-ra,rb-ra);
out=cross(rb-ra,r2-ra)./(A.*C-B.*B)*((C-B)./sqrt(A-2*B+C)+B./sqrt(A));
out=(pi*4e-7*I/(4*pi))*out;

