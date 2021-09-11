% sheets_rotate.m
% R = 3x3 rotation matrix
function out=sheets_rotate(sheets,R)
out=sheets;
for m=1:size(sheets,1)
  ra=out(m,1:3)';
  rb=out(m,4:6)';
  n=out(m,7:9)';
  ra2=R*ra;
  rb2=R*rb;
  n2=R*n;
  out(m,1:3)=ra2';
  out(m,4:6)=rb2';
  out(m,7:9)=n2';
end
