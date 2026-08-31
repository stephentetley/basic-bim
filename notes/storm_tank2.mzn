float: capacity;
float: width;
float: length;
float: surface_area;  
float: slope;
string: tank;

var 0.0 .. 100.0: height1;
var float: height2;

var float: C1; % capactity of simple rect
var float: C2; % capactity of "wedge"

% float_eq_2dp
predicate float_eq_2dp(float:d1, float:d2) =
  abs(d1 - d2) <= 0.01;
  
% float_eq_2dp
predicate float_eq_2dpv(float:d1, var float:d2) =
  abs(d1 - d2) <= 0.01;  

% surface area
constraint float_eq_2dp(width * length, surface_area);

% capacity of regular rect
constraint C1 = width * length * height1;
% capacity of "wedge"
constraint C2 = (slope / 2.0) * width * length;

constraint float_eq_2dpv(capacity, C1 + C2);

% height_max 
constraint height2 = height1 + slope;

solve satisfy;

output ["name = \(tank)\n",
         "height1_m = \(height1)\n",
         "height2_m = \(height2)\n",
         "regular_capacity_mm3 = \(C1)\n",
         "wedge_capacity_mm3 = \(C2)\n"
         ];