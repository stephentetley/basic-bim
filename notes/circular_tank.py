from build123d import *

tdiameter, theight = 600.0 * CM, 200.0 * CM
four_cm = 4.0 * CM
ten_cm = 10.0 * CM

with BuildPart() as ctank:
    with BuildSketch() as base_sketch:
        Circle(radius = tdiameter / 2.0) 
    extrude(amount=theight)  # Create a base block
    with BuildSketch(Plane(ctank.faces().sort_by(Axis.Z).last)) as cut_sketch:
        Circle(radius = tdiameter / 2.0 - four_cm)
    extrude(amount= (0-theight)+ten_cm, mode=Mode.SUBTRACT)  # Create a base block




export_brep(ctank.part, "./output/circular_tank_part.brep")
            
