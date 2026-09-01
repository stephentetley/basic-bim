// params
diameter=15;
inner_diameter= 10;
center_depth=8;
side_depth=4;
above_ground=true; 

// calculations
zdisplace = above_ground ? center_depth : 0;
radius = diameter/2;
inner_radius = inner_diameter/2;
cone_depth=center_depth-side_depth;


translate([0,0, zdisplace])  {
    // draw below ground...
    union() {
        translate([0,0, 0-side_depth/2]) {
          cylinder(h=side_depth,r=radius, $fn = 80, center=true);
        }
        translate([0,0, 0-(side_depth+(cone_depth/2))]) {
          cylinder(h=cone_depth,r1=inner_radius, r2=radius, $fn = 80, center=true);  
        }
    }
}