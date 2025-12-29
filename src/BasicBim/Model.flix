/*
 * Copyright 2025 Stephen Tetley
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */





mod BasicBim.Model {

    use Applicative.{<*, *>}
    use BasicBim.Base.Syntax.{Stmt, Expr, otherLiteral}
    use BasicBim.IfcGen
    use BasicBim.IfcGen.{runIfcGen, local, asks, pyImport, verbatim, pyAssignExpr}
    use BasicBim.Colour.NamedColours.{NamedColour}
    use BasicBim.Pset.Address
    use BasicBim.Pset.SiteCommon

    // TODO - having a context would allow users to extend imports 
    // and builtin functions (verbatims)

    // pub type alias BimContext[r: RecordRow] = {
    //     python_imports = List[String]

    //     | r
    // }

    // pub def initial_context(): BimContext[()] = {
    //     python_imports =  List#{
    //         "ifcopenshell.api.root", 
    //         "ifcopenshell.api.unit",
    //         "ifcopenshell.api.context",
    //         "ifcopenshell.api.project",
    //         "ifcopenshell.api.spatial",
    //         "ifcopenshell.api.geometry",
    //         "ifcopenshell.api.aggregate",
    //         "ifcopenshell.api.owner",
    //         "ifcopenshell.api.pset",
    //         "ifcopenshell.api.style",
    //         "numpy"
    //     }
    // }

    pub def writePy(path: String, mctx: {| cx}, m: IfcGen[cx, a]): (String, a) \ IO = 
        let (pycode, a) = showPy(mctx, m);
        run {
            match FileWriteWithResult.write(str = pycode, path){
                case Result.Ok(_)    => ()
                case Result.Err(err) =>
                    println("Unable to write file. Error: ${err}")
            }
        } with FileWriteWithResult.runWithIO;
        (pycode, a)



    pub def showPy(mctx: {| cx}, m: IfcGen[cx, a]): (String, a) = 
        let prgm = forM (
            _ <- Foldable.forEachM(pyImport, pyimports());
            _ <- blank();
            _ <- verbatim(make_placement_matrix());
            _ <- blank();
            _ <- verbatim(make_placement_angle_matrix());
            _ <- blank();
            ans <- m
        ) yield ans;
        let (code, _, a) = runIfcGen(mctx, Map.empty(), prgm);
        let pycode = BasicBim.Base.Syntax.ppCode(code);
        (pycode, a)

    def blank(): IfcGen[cx, Unit] = verbatim("")

    // TODO put these in a record as part of inital context?
    def pyimports(): List[String] = 
        List#{
            "ifcopenshell.api.root", 
            "ifcopenshell.api.unit",
            "ifcopenshell.api.context",
            "ifcopenshell.api.project",
            "ifcopenshell.api.spatial",
            "ifcopenshell.api.geometry",
            "ifcopenshell.api.aggregate",
            "ifcopenshell.api.owner",
            "ifcopenshell.api.pset",
            "ifcopenshell.api.style",
            "numpy"
        }

    def make_placement_matrix(): String = 
        String.unlines(List#{
            "def make_placement_matrix(x, y, z):",
            "    matrix = numpy.eye(4)",
            "    matrix[:,3][0:3] = (x, y, z)",
            "    return matrix"})

    def make_placement_angle_matrix(): String = 
        String.unlines(List#{
            "def make_placement_angle_matrix(deg, x, y, z):",
            "    matrix = numpy.eye(4)",
            "    matrix = ifcopenshell.util.placement.rotation(deg, 'Z') @ matrix",
            "    matrix[:,3][0:3] = (x, y, z)",
            "    return matrix"})



    pub def model[r: RecordRow, a: Type](version: String, ifcfile: String, body: IfcGen[(model = Expr | r), a]): IfcGen[( | r), a] = 
        let writeFile = BasicBim.API.Obj.File.write(path = ifcfile, format = ".ifc", zipped = false);
        forM (
            model <- BasicBim.API.Project.create_file(version=version);
            ans <- local(cx -> {+model=model| cx}, body <* writeFile)
        ) yield ans



    pub def ifcProject[r: RecordRow, a: Type](name: String, 
                                                body: IfcGen[(model = Expr, ifcproject = Expr | r), a]): IfcGen[(model = Expr | r), a] =
        forM (
            vproject <- BasicBim.API.Root.create_entity(ifc_class = "IfcProject", name = name);
            ans <- local(cx -> {+ifcproject=vproject| cx}, body)
        ) yield ans



    pub def ifcSite[r: RecordRow, a: Type](name: String, 
                                            body: IfcGen[(model = Expr, ifcproject = Expr, ifcsite = Expr | r), a]): IfcGen[(model = Expr, ifcproject = Expr | r), a] =
        forM (
            vsite <- BasicBim.API.Root.create_entity(ifc_class = "IfcSite", name = name);
            ans <- local(cx -> {+ifcsite=vsite| cx}, forM (
                prj <- asks(cx -> cx#ifcproject);
                _ <- BasicBim.API.Aggregate.assign_object(products=List#{vsite}, relating_object=prj);
                ans1 <- body
            ) yield ans1)
        ) yield ans


    pub def ifcBuilding[r: RecordRow, a: Type](name: String, 
                                                body: IfcGen[(model = Expr, ifcproject = Expr, ifcsite = Expr, ifcbuilding = Expr | r), a]): IfcGen[(model = Expr, ifcproject = Expr, ifcsite = Expr | r), a] =
        forM (
            vbuilding <- BasicBim.API.Root.create_entity(ifc_class = "IfcBuilding", name = name);
            ans <- local(cx -> {+ifcbuilding=vbuilding| cx}, forM (
                site <- asks(cx -> cx#ifcsite);
                _ <- BasicBim.API.Aggregate.assign_object(products=List#{vbuilding}, relating_object=site);
                ans1 <- body
            ) yield ans1)
        ) yield ans


    pub def ifcBuildingStorey[r: RecordRow, a: Type](name: String, 
                                                    body: IfcGen[(model = Expr, ifcproject = Expr, ifcsite = Expr, ifcbuilding = Expr, ifcbuildingstorey = Expr | r), a]): IfcGen[(model = Expr, ifcproject = Expr, ifcsite = Expr, ifcbuilding = Expr | r), a] =
        forM (
            vbuildingstorey <- BasicBim.API.Root.create_entity(ifc_class = "IfcBuildingStorey", name = name);
            ans <- local(cx -> {+ifcbuildingstorey=vbuildingstorey| cx}, forM (
                bldg <- asks(cx -> cx#ifcbuilding);
                _ <- BasicBim.API.Aggregate.assign_object(products=List#{vbuildingstorey}, relating_object=bldg);
                ans1 <- body
            ) yield ans1)
        ) yield ans        

    // Psets

    pub def setSiteAddress[r: RecordRow](f: Address.Pset_AddressSetter): IfcGen[(model = Expr, ifcproject = Expr, ifcsite = Expr | r), Expr] = 
        let props = BasicBim.Pset.Address.pset_Address(f) |> BasicBim.Pset.Address.toExpr;
        forM (
            site    <- asks(cx -> cx#ifcsite);
            pset1   <- BasicBim.API.Pset.add_pset(product=site, name="Pset_Address", ifc2x3_subclass=None);
            _       <- BasicBim.API.Pset.edit_pset(pset= pset1, properties=props)
        ) yield pset1

    pub def setSiteCommon[r: RecordRow](f: SiteCommon.Pset_SiteCommonSetter): IfcGen[(model = Expr, ifcproject = Expr, ifcsite = Expr | r), Expr] = 
        let props = BasicBim.Pset.SiteCommon.pset_SiteCommon(f) |> BasicBim.Pset.SiteCommon.toExpr;
        forM (
            site    <- asks(cx -> cx#ifcsite);
            pset1   <- BasicBim.API.Pset.add_pset(product=site, name="Pset_SiteCommon", ifc2x3_subclass=None);
            _       <- BasicBim.API.Pset.edit_pset(pset= pset1, properties=props)
        ) yield pset1




    def getColour(colour: NamedColour): IfcGen[cx, Expr] = 
        forM (
            var <- BasicBim.IfcGen.freshvarWithPrefix("colour");
            ans <- pyAssignExpr(var, BasicBim.Colour.NamedColours.toExpr(colour))
        ) yield ans

    pub def ifcSurfaceStyleShading[r: RecordRow](style_name: String, surface_colour: NamedColour, transparency: Float64): IfcGen[(model = Expr | r), Expr] = 
        forM (
            sty     <- BasicBim.API.Style.add_style(name = style_name, ifc_class = "IfcSurfaceStyle");            
            rgb     <- getColour(surface_colour);
            attrs   <- Applicative.point(Expr.Dict(List#{("SurfaceColour", rgb), ("Transparency", otherLiteral(transparency))}));
            _       <- BasicBim.API.Style.add_surface_style(style = sty, ifc_class = "IfcSurfaceStyleShading", attributes=attrs)
        ) yield sty
}
