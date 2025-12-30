import ifcopenshell.api.root
import ifcopenshell.api.unit
import ifcopenshell.api.context
import ifcopenshell.api.project
import ifcopenshell.api.spatial
import ifcopenshell.api.geometry
import ifcopenshell.api.aggregate
import ifcopenshell.api.owner
import ifcopenshell.api.pset
import ifcopenshell.api.style
import ifcopenshell.util.element
import numpy


def make_placement_matrix(x, y, z): 
    matrix = numpy.eye(4)
    matrix[:,3][0:3] = (x, y, z)
    return matrix

def make_placement_angle_matrix(deg, x, y, z): 
    matrix = numpy.eye(4)
    matrix = ifcopenshell.util.placement.rotation(deg, "Z") @ matrix
    matrix[:,3][0:3] = (x, y, z)
    return matrix

# Create a blank file
ifcfile = ifcopenshell.api.project.create_file(version="IFC4X3")

# ... and add a project
project = ifcopenshell.api.root.create_entity(file=ifcfile, 
                                              ifc_class="IfcProject", 
                                              name="Addley West Project")


# set project units
length_units = ifcopenshell.api.unit.add_si_unit(file=ifcfile, unit_type="LENGTHUNIT", prefix="MILLI")
area_units = ifcopenshell.api.unit.add_si_unit(file=ifcfile, unit_type="AREAUNIT")
ifcopenshell.api.unit.assign_unit(file=ifcfile, units=[length_units, area_units])


# Let's create a modeling geometry context, so we can store 3D geometry (note: IFC supports 2D too!)
context = ifcopenshell.api.context.add_context(file=ifcfile, context_type="Model")

# In particular, in this example we want to store the 3D "body" geometry of objects, i.e. the body shape
body = ifcopenshell.api.context.add_context(file=ifcfile, 
                                            context_type="Model",
                                            context_identifier="Body", 
                                            target_view="MODEL_VIEW", 
                                            parent=context)


author = ifcopenshell.api.owner.add_person(file=ifcfile,
                                           identification="tetleys", 
                                           family_name="Tetley",
                                           given_name="Stephen"
                                           )

application = ifcopenshell.api.owner.add_application(file=ifcfile,
                                                     application_developer=author,
                                                     application_full_name="ifc-through-python")






site = ifcopenshell.api.root.create_entity(file=ifcfile, ifc_class="IfcSite", name="Addley West STW")
ifcopenshell.api.aggregate.assign_object(file=ifcfile, relating_object=project, products=[site])

site_common_properties = {'TotalArea': 1492}
pset_site_common = ifcopenshell.api.pset.add_pset(file=ifcfile, product=site, name="Pset_SiteCommon")
ifcopenshell.api.pset.edit_pset(file=ifcfile, 
                                pset=pset_site_common, 
                                properties=site_common_properties)

site_address_properties = {'PostalCode': "S61 4BL",
                           'Country': 'GB',
                           'Town': None}
pset_address_site = ifcopenshell.api.pset.add_pset(file=ifcfile, product=site, name="Pset_Address")
ifcopenshell.api.pset.edit_pset(file=ifcfile, 
                                pset=pset_address_site, 
                                properties=site_address_properties)



mcc_kiosk = ifcopenshell.api.root.create_entity(file=ifcfile, ifc_class="IfcBuilding", name="MCC Kiosk")
ifcopenshell.api.aggregate.assign_object(file=ifcfile, relating_object=site, products=[mcc_kiosk])

mcc_kiosk_storey1 = ifcopenshell.api.root.create_entity(file=ifcfile, 
                                                        ifc_class="IfcBuildingStorey", 
                                                        name="MCC Kiosk Storey")
ifcopenshell.api.aggregate.assign_object(file=ifcfile, 
                                         relating_object=mcc_kiosk, 
                                         products=[mcc_kiosk_storey1])

admin_building = ifcopenshell.api.root.create_entity(file=ifcfile, 
                                                     ifc_class="IfcBuilding", 
                                                     name="Admin Building")
ifcopenshell.api.aggregate.assign_object(file=ifcfile, relating_object=site, products=[admin_building])

admin_building_storey1 = ifcopenshell.api.root.create_entity(file=ifcfile, 
                                                             ifc_class="IfcBuildingStorey", 
                                                             name="Admin Ground Floor")
ifcopenshell.api.aggregate.assign_object(file=ifcfile, 
                                         relating_object=admin_building, 
                                         products=[admin_building_storey1])

admin_building_storey2 = ifcopenshell.api.root.create_entity(file=ifcfile, 
                                                             ifc_class="IfcBuildingStorey", 
                                                             name="Admin First Floor")
ifcopenshell.api.aggregate.assign_object(file=ifcfile, 
                                         relating_object=admin_building, 
                                         products=[admin_building_storey2])


# kiosk front wall

mcc_kiosk_front_wall = ifcopenshell.api.root.create_entity(file=ifcfile, 
                                                           ifc_class='IfcWall', 
                                                           name='MCC Kiosk Front Wall', 
                                                           predefined_type='NOTDEFINED')
ifcopenshell.api.spatial.assign_container(file=ifcfile, 
                                          products=[mcc_kiosk_front_wall], 
                                          relating_structure=mcc_kiosk_storey1)

mcc_kiosk_front_wall_repr = ifcopenshell.api.geometry.add_wall_representation(file=ifcfile,
                                                                              context=body, 
                                                                              length=2.0, 
                                                                              height=1.4, 
                                                                              thickness=0.01)
# Assign our new body geometry back to our wall
ifcopenshell.api.geometry.assign_representation(file=ifcfile, 
                                                product=mcc_kiosk_front_wall, 
                                                representation=mcc_kiosk_front_wall_repr)

kiosk_wall_colour = { "Name": 'kiosk_green', "Red": 0.0, "Green": 0.9, "Blue": 0.1 }
kiosk_wall_style = ifcopenshell.api.style.add_style(file=ifcfile)
ifcopenshell.api.style.add_surface_style(file=ifcfile,
                                         style=kiosk_wall_style,
                                         ifc_class='IfcSurfaceStyleShading',
                                         attributes={"SurfaceColour": kiosk_wall_colour})

ifcopenshell.api.style.assign_representation_styles(file=ifcfile,
                                                    shape_representation=mcc_kiosk_front_wall_repr, 
                                                    styles=[kiosk_wall_style])

# mcc kiosk back wall

mcc_kiosk_back_wall_repr = ifcopenshell.util.element.copy_deep(ifc_file=ifcfile, 
                                                               element=mcc_kiosk_front_wall_repr)
mcc_kiosk_back_wall = ifcopenshell.api.root.create_entity(file=ifcfile, 
                                                          ifc_class='IfcWall', 
                                                          name='MCC Kiosk Back Wall', 
                                                          predefined_type='SOLIDWALL')
ifcopenshell.api.spatial.assign_container(file=ifcfile, 
                                          relating_structure=mcc_kiosk_storey1, 
                                          products=[mcc_kiosk_back_wall])
ifcopenshell.api.geometry.assign_representation(file=ifcfile, 
                                                product=mcc_kiosk_back_wall, 
                                                representation=mcc_kiosk_back_wall_repr)

mcc_kiosk_back_wall_placement = make_placement_matrix(0, 1.2, 0)

ifcopenshell.api.geometry.edit_object_placement(file=ifcfile, 
                                                product=mcc_kiosk_back_wall, 
                                                matrix=mcc_kiosk_back_wall_placement)


ifcopenshell.api.style.assign_representation_styles(file=ifcfile,
                                                    shape_representation=mcc_kiosk_back_wall_repr, 
                                                    styles=[kiosk_wall_style])

# mcc kiosk left wall
mcc_kiosk_left_wall = ifcopenshell.api.root.create_entity(file=ifcfile, 
                                                          ifc_class='IfcWall', 
                                                          name='MCC Kiosk Left Wall', 
                                                          predefined_type='SOLIDWALL'
)
ifcopenshell.api.spatial.assign_container(file=ifcfile, 
                                          relating_structure=mcc_kiosk_storey1, 
                                          products=[mcc_kiosk_left_wall])


mcc_kiosk_left_wall_repr = ifcopenshell.api.geometry.add_wall_representation(file=ifcfile, 
                                                                             context=body, 
                                                                             length=1.2, 
                                                                             height=1.4, 
                                                                             thickness=0.01)
ifcopenshell.api.geometry.assign_representation(file=ifcfile, 
                                                product=mcc_kiosk_left_wall, 
                                                representation=mcc_kiosk_left_wall_repr)

mcc_kiosk_left_wall_placement = make_placement_angle_matrix(90, 0, 0, 0)

ifcopenshell.api.geometry.edit_object_placement(file=ifcfile, 
                                                product=mcc_kiosk_left_wall, 
                                                matrix=mcc_kiosk_left_wall_placement)

ifcopenshell.api.style.assign_representation_styles(file=ifcfile,
                                                    shape_representation=mcc_kiosk_left_wall_repr, 
                                                    styles=[kiosk_wall_style])

# mcc kiosk right wall
mcc_kiosk_right_wall = ifcopenshell.api.root.create_entity(file=ifcfile, 
                                                           ifc_class='IfcWall', 
                                                           name='MCC Kiosk Right Wall', 
                                                           predefined_type='SOLIDWALL'
)
ifcopenshell.api.spatial.assign_container(file=ifcfile, 
                                          relating_structure=mcc_kiosk_storey1,
                                          products=[mcc_kiosk_right_wall])

mcc_kiosk_right_wall_repr = ifcopenshell.util.element.copy_deep(ifc_file=ifcfile, 
                                                                element=mcc_kiosk_left_wall_repr)

ifcopenshell.api.geometry.assign_representation(file=ifcfile, 
                                                product=mcc_kiosk_right_wall, 
                                                representation=mcc_kiosk_right_wall_repr)

ifcopenshell.api.geometry.edit_object_placement(file=ifcfile, 
                                                product=mcc_kiosk_right_wall, 
                                                matrix= make_placement_angle_matrix(90, 2.0, 0, 0))

ifcopenshell.api.style.assign_representation_styles(file=ifcfile, 
                                                    shape_representation=mcc_kiosk_right_wall_repr, 
                                                    styles=[kiosk_wall_style])

# connect walls
rel_connect_paths = [
    ifcopenshell.api.geometry.connect_path(file=ifcfile, 
                                           relating_element=mcc_kiosk_front_wall, 
                                           related_element=mcc_kiosk_right_wall,
                                           relating_connection='ATEND', 
                                           related_connection='ATSTART'),
    
    ifcopenshell.api.geometry.connect_path(file=ifcfile, 
                                           relating_element=mcc_kiosk_right_wall, 
                                           related_element=mcc_kiosk_back_wall,
                                           relating_connection='ATEND', 
                                           related_connection='ATSTART'),

    ifcopenshell.api.geometry.connect_path(file=ifcfile, 
                                           relating_element=mcc_kiosk_back_wall, 
                                           related_element=mcc_kiosk_left_wall,
                                           relating_connection='ATEND', 
                                           related_connection='ATSTART'),

    ifcopenshell.api.geometry.connect_path(file=ifcfile, 
                                           relating_element=mcc_kiosk_left_wall, 
                                           related_element=mcc_kiosk_front_wall,
                                           relating_connection='ATEND',
                                           related_connection='ATSTART')
]

point_list = ifcfile.create_entity('IfcCartesianPointList2D', CoordList = [[-1., -1.], [1., 1.]])
curve_on_relating = ifcfile.create_entity('IfcIndexedPolyCurve', Points=point_list)
connection_curve = ifcfile.create_entity(
    'IfcConnectionCurveGeometry', CurveOnRelatingElement=curve_on_relating
)

# TODO - eliminate loop
for path in rel_connect_paths:
    path.ConnectionGeometry = connection_curve

# mcc kiosk footing
mcc_kiosk_footing = ifcopenshell.api.root.create_entity(file=ifcfile,
                                                        ifc_class='IfcFooting', 
                                                        name='Footing', 
                                                        predefined_type='STRIP_FOOTING')
ifcopenshell.api.spatial.assign_container(file=ifcfile, 
                                          relating_structure=mcc_kiosk_storey1, 
                                          products=[mcc_kiosk_footing])

kiosk_wall_thickness = 0.01
kiosk_footing_ledge = 0.05
mcc_kiosk_storey_size = {"x": 2.0, "y": 1.2, "z": 1.4}
mcc_footing_size = {
    'x': mcc_kiosk_storey_size['x'] + 2 * (kiosk_wall_thickness + kiosk_footing_ledge),
    'y': mcc_kiosk_storey_size['y'] + 2 * (kiosk_wall_thickness + kiosk_footing_ledge),
    'z': 0.02
    }

mcc_kiosk_footing_repr = ifcopenshell.api.geometry.add_wall_representation(file=ifcfile, 
                                                                           context=body,
                                                                           length=2.4, 
                                                                           height=0.05, 
                                                                           thickness=1.6)

ifcopenshell.api.geometry.assign_representation(file=ifcfile, 
                                                product=mcc_kiosk_footing, 
                                                representation=mcc_kiosk_footing_repr)

mcc_kiosk_footing_placement = make_placement_matrix(-0.2, -0.2, 0)


ifcopenshell.api.geometry.edit_object_placement(file=ifcfile, 
                                                product=mcc_kiosk_footing, 
                                                matrix=mcc_kiosk_footing_placement)


footing_colour = { "Name": 'kiosk_green', "Red": 0.8, "Green": 0.9, "Blue": 0.15 }
footing_style = ifcopenshell.api.style.add_style(file=ifcfile)
ifcopenshell.api.style.add_surface_style(file=ifcfile, 
                                         style=footing_style, 
                                         ifc_class='IfcSurfaceStyleShading',
                                         attributes={"SurfaceColour": footing_colour, 
                                                     "Transparency": 0.2})

ifcopenshell.api.style.assign_representation_styles(file=ifcfile, 
                                                    shape_representation=mcc_kiosk_footing_repr, 
                                                    styles=[footing_style])

# Write out to a file
ifcfile.write("./output/working1.ifc")

