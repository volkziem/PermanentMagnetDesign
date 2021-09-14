h=6;    // height
ro=15;  // outer radius
ri=5;   // inner radius
M=8;    // number of magnets
a=5.2;  // size of the hole for the cubes
r=11;   // radial displacement of hole center
m=1;    // multipolarity (1: dipole, 2: quadrupole)
//phi=45; 

module frame_ring(h,ro,ri){
    difference() {
        cylinder(h,r=ro,$fn=36,center=true);
        cylinder(2*h,r=ri,$fn=36,center=true);
    }
}
//frame_ring(h,ro,ri);

module magnet_cube(a,r,m,phi) {
rotate([0,0,phi]) translate([r,0,0]) 
    rotate([0,0,m*phi]) cube([a,a,a],center=true);
}

module magnet_holes(M) {
    for (i=[0:M-1]) magnet_cube(a,r,m,i*360/M);
}

difference (){
  frame_ring(h,ro,ri);
  translate([0,0,0.5]) magnet_holes(M);
}