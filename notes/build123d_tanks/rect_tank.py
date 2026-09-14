from build123d import *

tlength, twidth, theight = 800.0 * CM, 450.0 * CM, 200.0 * CM
four_cm = 4.0 * CM
ten_cm = 10.0 * CM


walls = (Pos(0.0, 0.0) * Rectangle(height=tlength, width=twidth) 
           - Pos(0.0, 0.0) * Rectangle(height=tlength - ten_cm, width=twidth - ten_cm))
part1 = extrude(walls, theight)

base = (Pos(0.0, 0.0) * Rectangle(height=tlength, width=twidth))
part2 = extrude(base, ten_cm)

parts = (part1 + part2).translate((0, 0, 0-theight / 2.0))

export_brep(parts, "./output/rect_tank_algebra.brep")
            
