% Bsheets.m, V. Ziemann, 210910
function Bout=Bsheets(sheets,r2)
Bout=zeros(3,1);
for m=1:size(sheets,1)
  ra=sheets(m,1:3)'; rb=sheets(m,4:6)'; nn=sheets(m,7:9)'; 
  alpha=sheets(m,10); Br=sheets(m,11);
  pp=alpha*cross(rb-ra,nn);  % vector along other sheet direction
  A=dot(r2-ra,r2-ra);
  B=dot(r2-ra,rb-ra);
  C=dot(rb-ra,rb-ra);
  D=dot(r2-ra,pp);

  a1=A*C-2*B*C+C*C;
  b1=-2*C*D;
  c1=alpha^2*C^2;
  p1=-(C-B)^2;

  a2=A*C;
  b2=-2*C*D;
  c2=alpha^2*C^2;
  p2=-B^2;

  JJ1=integral_GR2284(0,1,a1,b1,c1,p1);
  JJ2=integral_GR2284(1,0,a1,b1,c1,p1);
  JJ3=integral_GR2284(0,1,a2,b2,c2,p2);
  JJ4=integral_GR2284(1,0,a2,b2,c2,p2);

  out=cross(rb-ra,r2-ra)*alpha*C*((C-B)*JJ1+B*JJ3) ...
       +alpha^2*C^2*nn*((C-B)*JJ2+ B*JJ4);
  out=out*Br/(4*pi);
  Bout=Bout+out;
end

end

% integrates QQ=@(x)(AA*x+BB)./((p+R(x)).*sqrt(R(x)));
% with R=@(x)a+b*x+c*x*x; between -0.5 and +0.5.
% Gradsteyn and Ryshik, p. 123 integral 2.284
% there seems to be a typo in G+R, the sign of I2 seems to be reversed    
function out=integral_GR2284(AA,BB,a,b,c,p)
disc=p*(b*b-4*(a+p)*c);
%tmp=b*b-4*(a+p)*c;
x=0.5; Ru=a+b*x+c*x*x;
x=-0.5; Rl=a+b*x+c*x*x;
% first I1
if abs(p)<1e-9
  I1=0;
elseif p>0  % OK, checked ith AA only
  %disp(['I1: p>0 ',num2str(disc),' ',num2str(p)])
  I1=(atan(sqrt(Ru/p))-atan(sqrt(Rl/p)))/sqrt(p);
else   % OK, checked ith AA only
  %disp(['I1: p<0 ',num2str(disc),' ',num2str(p)])
  tmpu=log((sqrt(-p)-sqrt(Ru))/(sqrt(-p)+sqrt(Ru)));
  tmpl=log((sqrt(-p)-sqrt(Rl))/(sqrt(-p)+sqrt(Rl)));
  I1=0.5*(tmpu-tmpl)/sqrt(-p);
end
% second I2
if disc>0  % OK, checked with BB only
  %disp('I2: disc>0')
  I2=-atan(sqrt(p/(b*b-4*(a+p)*c))*(b+2*c*0.5)/sqrt(Ru)) ...
     +atan(sqrt(p/(b*b-4*(a+p)*c))*(b-2*c*0.5)/sqrt(Rl));
else
  if p>0   % OK, checked with BB only
    %disp(['I2: disc<0, p>0 ',num2str(disc),' ',num2str(p)])
    tmp1u=sqrt(4*(a+p)*c-b*b)*sqrt(Ru);
    tmp2u=sqrt(p)*(b+2*c*0.5);
    tmp1l=sqrt(4*(a+p)*c-b*b)*sqrt(Rl);
    tmp2l=sqrt(p)*(b-2*c*0.5);
    I2=(0.5/1i)*(log((tmp1u+tmp2u)/(tmp1u-tmp2u)) ...
    - log((tmp1l+tmp2l)/(tmp1l-tmp2l)));
  else   %OK, checked with BB only
    %disp(['I2: disc<0, p<0 ',num2str(disc),' ',num2str(p)])
    tmp1u=sqrt(b*b-4*(a+p)*c)*sqrt(Ru);
    tmp2u=sqrt(-p)*(b+2*c*0.5);
    tmp1l=sqrt(b*b-4*(a+p)*c)*sqrt(Rl);
    tmp2l=sqrt(-p)*(b-2*c*0.5);
    I2=(0.5/1i)*(log((tmp1u-tmp2u)/(tmp1u+tmp2u)) ...
    - log((tmp1l-tmp2l)/(tmp1l+tmp2l)));
    if isnan(I2) I2=0; end
  end
end
I2=-I2;  % typo in G+R?

%AABB=[AA,BB,I1,I2,disc]

if abs(I2)< 1e-9
  out=AA*I1/c;
else
  out=AA*I1/c+(2*BB*c-AA*b)*I2/sqrt(c*c*disc);  
end
end