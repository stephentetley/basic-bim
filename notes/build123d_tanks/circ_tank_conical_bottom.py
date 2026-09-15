from build123d import *

tdiameter, cyheight, coheight = 600.0 * CM, 80.0 * CM, 120.0 * CM
wall = 4.0 * CM

extcylinder = Pos(0, 0, coheight + cyheight * 0.5) * Cylinder(radius=tdiameter / 2.0, height=cyheight)
extcone = Pos(0, 0, coheight * 0.5) * Cone(bottom_radius=2.0*wall, top_radius=tdiameter / 2.0, height=coheight)

# Combine objects using algebraic operators
exttank = extcylinder + extcone

topf = exttank.faces().sort_by().last
tank = offset(exttank, amount=-wall, openings=topf)

export_brep(tank, "./output/circ_tank_conical_bottom.brep")
            
