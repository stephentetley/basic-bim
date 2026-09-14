from build123d import *

tdiameter, theight = 600.0 * CM, 200.0 * CM
four_cm = 4.0 * CM
ten_cm = 10.0 * CM


walls = (Pos(0.0, 0.0) * Circle(radius=tdiameter / 2.0) 
           - Pos(0.0, 0.0) * Circle(radius=tdiameter / 2.0 - four_cm))
part1 = extrude(walls, theight)

base = (Pos(0.0, 0.0) * Circle(radius=tdiameter / 2.0))
part2 = extrude(base, four_cm)

parts = (part1 + part2).translate((0, 0, 0-theight / 2.0))

export_brep(parts, "./output/circular_tank_algebra.brep")
            
