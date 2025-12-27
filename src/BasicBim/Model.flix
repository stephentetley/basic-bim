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


    use BasicBim.Base.Syntax.{Stmt, Expr}


    use BasicBim.IfcGen
    use BasicBim.IfcGen.{runIfcGen, local, pyImport}


    // pub enum SourceContext
    // pub enum ModelContext

    // // pub type alias Source[a] = IfcGen[SourceContext, a]

    // pub enum ModelCx
    // pub enum ProjectCx

    // pub type alias Model[a] = IfcGen[ModelCx, a]
    // pub type alias Project[a] = IfcGen[ProjectCx, a]

    pub def showPy(ctx: {| cx}, m: IfcGen[cx, a]): (String, a) = 
        let (code, _, a) = runIfcGen(ctx, 1, m);
        let pycode = BasicBim.Base.Syntax.ppCode(code);
        (pycode, a)


    // TODO put these in a record as part of inital context...
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



    pub def model[r: RecordRow, a: Type](version: String, _ifcfile: String, body: IfcGen[(model = Expr | r), a]): IfcGen[( | r), a] = 
        forM (
            _ <- Foldable.forEachM(pyImport, pyimports());
            model <- BasicBim.API.Project.create_file(version=version);
            ans <- local(cx -> {+model=model| cx}, body)
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
