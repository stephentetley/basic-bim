from build123d import *

tdiameter, theight = 600.0 * CM, 200.0 * CM
four_cm = 4.0 * CM
wall = four_cm

exttank = Pos(0.0, 0.0, theight * 0.5) * Cylinder(radius=tdiameter / 2.0, height=theight)

topf = exttank.faces().sort_by().last
tank = offset(exttank, amount=-wall, openings=topf)

export_brep(tank, "./output/circ_tank_flat_bottom.brep")
            
