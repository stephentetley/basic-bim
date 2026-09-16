from build123d import *

# rectangular, sloping bottom tank made with a wedge

tlength = 40.0
twitdh = 25.0
theight1 = 15.0
theight2 = 8.0
wall = 0.8



sktwedge = Wedge(
    xsize=twitdh,  # Length of near face along x-axis
    ysize=tlength,  # Depth along y-axis
    zsize=theight1,  # Height of near face along z-axis
    xmin=0.0,    # Minimum x coordinate of far face
    zmin=theight1-theight2,    # Minimum z coordinate of far face
    xmax=twitdh,    # Maximum x coordinate of far face
    zmax=theight1    # Maximum z coordinate of far face
)

exttank = Pos(0,0,0 - 0.5 * theight1) * sktwedge

topf = exttank.faces().sort_by().last
tank = offset(exttank, amount=-wall, openings=topf)


export_brep(tank, "./output/rect_tank_wedge.brep")