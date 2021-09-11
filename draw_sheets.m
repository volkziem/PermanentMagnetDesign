% draw_sheets.m
function draw_sheets(sheet)
ra=sheet(1:3); rb=sheet(4:6); nn=sheet(7:9); alpha=sheet(10);
% plot current loop
plot3([ra(1),rb(1)],[ra(2),rb(2)],[ra(3),rb(3)],'g','LineWidth',2)
% normal vectors
rc=0.5*(ra+rb);
% plot normal vector of sheet in magneta
quiver3(rc(1),rc(2),rc(3),nn(1),nn(2),nn(3),'m','LineWidth',2)

p2=0.5*alpha*cross(rb-ra,nn); % normal in plane
r1=ra-p2; r2=rb-p2 ; r3=rb+p2; r4=ra+p2; r5=r1; % closed path
x=[r1(1),r2(1),r3(1),r4(1),r5(1)];
y=[r1(2),r2(2),r3(2),r4(2),r5(2)];
z=[r1(3),r2(3),r3(3),r4(3),r5(3)];
blue=0.6+0.4*rand;
green=0.2+0.4*rand;
fill3(x,y,z,[0.0, green, blue])

% plot easyaxis as yellow arrow
rr=rc+p2; dr=-2*p2;
quiver3(rr(1),rr(2),rr(3),dr(1),dr(2),dr(3),'y','LineWidth',3)%,'MaxHeadSize',0.3)




