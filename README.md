# basic-bim

BIM-as-code / IfcOpenShell generation experiment

`basic-bim` is a monadic DSL embedded in Flix to generate IFC 
BIM models.

`basic-bim` generates a "straight line" Python (.py) program, 
i.e it contains no loops or if-then-else statements. The (.py) 
file must be run by Python to create an IFC Step (.ifc) file
that can be viewed in Bonsai (the Blender BIM extension), 
FreeCAD, etc. The Python environment must include the 
`IfcOpenShell` package, currently version 0.8.4, and its 
dependencies.

