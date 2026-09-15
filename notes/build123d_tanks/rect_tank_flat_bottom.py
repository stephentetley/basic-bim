from build123d import *

tlength, twidth, theight = 800.0 * CM, 450.0 * CM, 200.0 * CM
ten_cm = 10.0 * CM

wall = ten_cm

exterior = (Pos(0.0, 0.0) * Rectangle(height=tlength, width=twidth))
exttank = extrude(exterior, theight)

topf = exttank.faces().sort_by().last
tank = offset(exttank, amount=-wall, openings=topf)


export_brep(tank, "./output/rect_tank_flat_bottom.brep")

