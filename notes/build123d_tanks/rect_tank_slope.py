from build123d import *

t = 1

# exterior
el1 = Line((0, 0), (0, -10))
el2 = Line(el1 @ 1, (40, -15))
el3 = Line(el2 @ 1, (40, 0))
el4 = Line(el3 @ 1, el1 @ 0)

exterior = el1 + el2 + el3 + el4
extface = Plane.YZ * make_face(exterior)
exttank = extrude(extface, 30.0)

# interior
il1 = Line((0 + t, 0), (0 + t, -10 + t))
il2 = Line(il1 @ 1, (40 - t , -15 + t))
il3 = Line(il2 @ 1, (40 - t, 0))
il4 = Line(il3 @ 1, il1 @ 0)
interior = il1 + il2 + il3 + il4
intface = (Plane.YZ * make_face(interior)).translate((t, 0, 0))
inttank = extrude(intface, 30.0 - 2.0 * t)

tank = exttank - inttank

export_brep(tank, "./output/rect_tank_sloped.brep")
            
