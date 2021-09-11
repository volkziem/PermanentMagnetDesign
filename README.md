# PermanentMagnetDesign
Matlab software for designing magnets with permanent magnet cubes. Used in the [course
on that topic (1FA362)](https://ziemann.web.cern.ch/ziemann/teaching/pm21/)
at Uppsala University.

The theory behind the code is described in two publications. Check them out
for the details

  - V. Ziemann, Closed-form expressions for the magnetic field of permanent magnets in
    three dimensions, [arXiv:2106.04153](https://arxiv.org/abs/2106.04153), June 2021.

  - V. Ziemann, Strap-on magnets: a framework for rapid prototyping of magnets and
    beam lines, [arXiv:2106.14676](https://arxiv.org/abs/2106.14676), June 2021.


## The description of the MATLAB files:

- **README.md**
  - this file

- **PM_multipoles.m**
  - main program to design multipole magnets,
  all plots are copied into a subdirectory named tmp/ 

- **PM_solenoid_axial.m**
  - main program to design axial solenoids
  all plots are copied into a subdirectory named tmp/ 

- **PM_solenoid_radial.m**
  - main program to design radial solenoids
  all plots are copied into a subdirectory named tmp/ 

- **Bsheets.m**
  - Bout=Bsheets(sheets,r2)
  - returns the field 'Bout(r2)' from the 'sheets'

- **draw_sheets.m**
  - draw_sheets(sheets)
  - draws the geometry of the 'sheets'

- **field_along_line2.m**
  - Bline=field_along_line2(sheets,line)
  - returns the field 'Bline' along the 'line' generated by the 'sheets'

- **field_from_sheets2D.m**
  - field_from_sheets2D(gx,gz,sheets,limit)
  - generates an arrow plot on a plane specified by the gridpoints 'gx' and 'gy'
  'limit' prevents drawing very large arrows

- **field_from_sheets3.m**
  - field_from_sheets3(gx,gy,gz,sheets,limit)
  - generates an arrow plot on the grid specified by 'gx', 'gy', and 'gz'

- **make_cubez.m**
  - sheets=make_cubez(a,alpha,Br)
  - returns the sheets of a cube with size 'a', aspect ratio 'alpha', and
  remanent field 'Br'

- **make_brick.m**
  - sheets=make_brick(a,b,c,Br)
  - returns the sheets of a brick with the specified sides.

- **make_polygon_hollow.m**
  - sheets=make_polygon_hollow(n,ri,ro,h,Br)
  - returns the sheets of a hollow polygon with 'n' sides, inner radius 'ri',
  outer radius 'ro', and  height 'h'.
 
- **make_polygon.m** 
  - sheets=make_polygon(n,r,h,Br)
  - returns the sheets of a polygon with 'n' sides, radius 'r', and  height 'h'.

- **sheets_rotate.m** 
  - out=sheets_rotate(sheets,R)
  - returns the 'sheets' after transfroming them with a 3x3 rotation matrix 'R'.

- **sheets_rotate_x.m** 
  - out=sheets_rotate_x(sheets,phi)
  - rotates the sheets by angle 'phi' (in degree) around the x-axis
  there are corresponding functions to implement rotations around the other two axes.

- **sheets_translate.m**
  - out=sheets_translate(sheets,dx)
  - returns the 'sheets' after translating them by 'dx'.

## Disclaimer

I do not claim that this software serves any purpose. You use it at your own risk. 
