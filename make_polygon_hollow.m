% make_polygon_hollow.m
function out=make_polygon_hollow(n,ri,ro,h,Br)
if nargin==4, Br=1; end
out=zeros(n,11);
degrees=pi/180;
phi=360/n; cx=cos(0.5*phi*degrees); sx=sin(0.5*phi*degrees);
ra=[ro*cx,-ro*sx,0]; rb=[ro*cx,ro*sx,0]; nn=[1,0,0]; alpha=h/(2*ro*sx);
out(1,:)=[ra,rb,nn,alpha,Br];
for k=2:n
  out(k,:)=sheets_rotate_z(out(1,:),(k-1)*phi);
end

ra=[ri*cx,ri*sx,0]; rb=[ri*cx,-ri*sx,0]; nn=[-1,0,0]; alpha=h/(2*ri*sx);
out(n+1,:)=[ra,rb,nn,alpha,Br];
for k=2:n
  out(n+k,:)=sheets_rotate_z(out(n+1,:),-(k-1)*phi);
end