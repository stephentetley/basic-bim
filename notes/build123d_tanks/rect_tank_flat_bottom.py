from build123d import *

tlength, twidth, theight = 800.0 * CM, 450.0 * CM, 200.0 * CM
wall = 10.0 * CM

exttank = (Pos(0.0, 0.0, theight * 0.5) * Box(length=tlength, width=twidth, height=theight))

topf = exttank.faces().sort_by().last
tank = offset(exttank, amount=-wall, openings=topf)


export_brep(tank, "./output/rect_tank_flat_bottom.brep")

