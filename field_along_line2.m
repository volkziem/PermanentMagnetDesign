% field_along_line.m
function Bline=field_along_line2(sheets,line)
Bline=zeros(size(line));
for k=1:size(line,2)  % loop over points on line
  r2=line(:,k); 
  Bline(:,k)=Bsheets(sheets,r2);
end
