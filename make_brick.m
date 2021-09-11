% make_brick.m
function out=make_brick(a,b,c,Br)
if nargin==3, Br=1; end
out=zeros(4,11);
ra=0.5*[a,-b,0]; rb=0.5*[a,b,0]; n=[1,0,0]; alpha=c/b;
out(1,:)=[ra,rb,n,alpha,Br];
ra=rb; rb=0.5*[-a,b,0]; n=[0,1,0]; alpha=c/a;
out(2,:)=[ra,rb,n,alpha,Br];
ra=rb; rb=0.5*[-a,-b,0]; n=[-1,0,0]; alpha=c/b;
out(3,:)=[ra,rb,n,alpha,Br];
ra=rb; rb=0.5*[a,-b,0]; n=[0,-1,0]; alpha=c/a;
out(4,:)=[ra,rb,n,alpha,Br];
