from build123d import *

wall = 2.0 

# Define the front wire
wire_front = Pos(0, 0, 15) * Wire.make_rect(40, 30, Plane.XZ)

wire_middle = Pos(0, 40, 15) * Wire.make_rect(40, 30, plane=Plane.XZ)

wire_back = Pos(0, 70, 20) * Wire.make_rect(40, 20, plane=Plane.XZ)

# # Generate the solid via Direct API
loft_solid = Solid.make_loft([wire_front, wire_middle, wire_back], ruled=True)


topf = loft_solid.faces()[3]
tank = offset(loft_solid, amount=-wall, openings=topf)

for ix, face in enumerate(loft_solid.faces()):
    export_brep(face, f"./output/rect_flat_sloped_loft_face{ix}.brep")
    print(face)

export_brep(tank, "./output/rect_flat_sloped_loft.brep")