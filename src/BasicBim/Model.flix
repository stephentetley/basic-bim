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

    use Applicative.{<*}
    use BasicBim.Base.Syntax.{Stmt, Expr}


    use BasicBim.IfcGen
    use BasicBim.IfcGen.{runIfcGen, local, pyImport, verbatim}

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
        let (code, _, a) = runIfcGen(mctx, Map#{"v" => 1}, prgm);
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
            ans <- local(cx -> {+ifcsite=vsite| cx}, body)
        ) yield ans


    pub def ifcBuilding[r: RecordRow, a: Type](name: String, 
                                                body: IfcGen[(model = Expr, ifcproject = Expr, ifcsite = Expr, ifcbuilding = Expr | r), a]): IfcGen[(model = Expr, ifcproject = Expr, ifcsite = Expr | r), a] =
        forM (
            vbuilding <- BasicBim.API.Root.create_entity(ifc_class = "IfcBuilding", name = name);
            ans <- local(cx -> {+ifcbuilding=vbuilding| cx}, body)
        ) yield ans


    pub def ifcBuildingStorey[r: RecordRow, a: Type](name: String, 
                                                    body: IfcGen[(model = Expr, ifcproject = Expr, ifcsite = Expr, ifcbuilding = Expr, ifcbuildingstorey = Expr | r), a]): IfcGen[(model = Expr, ifcproject = Expr, ifcsite = Expr, ifcbuilding = Expr | r), a] =
        forM (
            vbuildingstorey <- BasicBim.API.Root.create_entity(ifc_class = "IfcBuildingStorey", name = name);
            ans <- local(cx -> {+ifcbuildingstorey=vbuildingstorey| cx}, body)
        ) yield ans        


}
