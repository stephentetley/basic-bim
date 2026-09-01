// params
diameter=15;
depth=4;
above_ground=true; 

// calculations
zdisplace = above_ground ? depth/2 : 0-(depth/2);
radius = diameter/2;

translate([0,0, zdisplace])  
  cylinder(h=depth,r=radius, $fn = 80, center=true);