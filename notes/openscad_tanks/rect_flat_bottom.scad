// params
length=20;
width=15;
depth=4;
above_ground=false; 

// calculations
zdisplace = above_ground ? depth/2 : 0-(depth/2);

translate([0,0, zdisplace])  
  cube([length,width,depth], center=true);