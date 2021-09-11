% make_cube_z.m
function out=make_cubez(a,alpha,Br)
if nargin==2, Br=1; end
a2=0.5*a;
ra1=[a2;-a2;0]; rb1=[a2;a2;0]; nn1=[1;0;0];
ra2=rb1; rb2=[-a2;a2;0]; nn2=[0;1;0];
ra3=rb2; rb3=[-a2;-a2;0]; nn3=[-1;0;0];
ra4=rb3; rb4=ra1; nn4=[0;-1;0];
out=[ra1',rb1',nn1',alpha,Br;
  ra2',rb2',nn2',alpha,Br;
  ra3',rb3',nn3',alpha,Br;
  ra4',rb4',nn4',alpha,Br
];
end
