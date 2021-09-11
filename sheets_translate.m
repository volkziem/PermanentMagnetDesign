% sheet_translate.m
% dx = column vector of translations
function out=sheets_translate(sheets,dx)
out=sheets;
for m=1:size(sheets,1)
  out(m,1:3)=out(m,1:3)+dx';
  out(m,4:6)=out(m,4:6)+dx';
end

