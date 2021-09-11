% field_from_sheets2D.m
function field_from_sheets2D(gx,gz,sheets,limit)
x=gx;
z=gz;
[XX,ZZ]=meshgrid(x,z); YY=0*ZZ;
BX=0*XX;
BY=0;        % at plane y=0;
BZ=0*ZZ;
%[length(gx),length(gz),size(XX),size(ZZ)]
for kx=1:length(gz)     % swapped gx and gz here
  for kz=1:length(gx)   % and here
    xx=XX(kx,kz); yy=0; zz=ZZ(kx,kz);
    %if (abs(xx)>a2) | (abs(yy)>a2) | (abs(zz)>a2) 
      r2=[xx;yy;zz]; % B=zeros(3,1);
       B=Bsheets(sheets,r2);
%       for m=1:size(sheets,1)  % loop over sheets
%         ra=sheets(m,1:3)'; rb=sheets(m,4:6)'; nn=sheets(m,7:9)'; 
%         alpha=sheets(m,10); Br=sheets(m,11);
%         B=B+Bsheet(r2,Br,ra,rb,nn,alpha);
%       end
      BX(kx,kz)=B(1);
      BY(kx,kz)=B(2);
      BZ(kx,kz)=B(3);
    %end
  end
end
BX(abs(BX)>limit)=NaN; BY(abs(BY)>limit)=NaN; BZ(abs(BZ)>limit)=NaN;
quiver3(XX,YY,ZZ,BX,BY,BZ,'LineWidth',2,'Color','r')
xlabel('x'); ylabel('y'); zlabel('z')
set(gca,'FontSize',16)
