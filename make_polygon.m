% make_polygon.m
function out=make_polygon(n,r,h,Br)
if nargin==3, Br=1; end
out=zeros(n,11);
degrees=pi/180;
phi=360/n; cx=cos(0.5*phi*degrees); sx=sin(0.5*phi*degrees);
ra=[r*cx,-r*sx,0]; rb=[r*cx,r*sx,0]; nn=[1,0,0]; alpha=h/(2*r*sx);
out(1,:)=[ra,rb,nn,alpha,Br];
for k=2:n
  out(k,:)=sheets_rotate_z(out(1,:),(k-1)*phi);
end