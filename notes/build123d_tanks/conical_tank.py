from build123d import *

theight=10
wall = 1

# bottom radius must be >0
extcone = Pos(0, 0, theight * 0.5) * Cone(bottom_radius=1, top_radius=20, height=theight)

topf = extcone.faces().sort_by().last
tank = offset(extcone, amount=-wall, openings=topf)


export_brep(tank, "./output/conical_tank.brep")