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


    use BasicBim.Base.Syntax.{Stmt}


    use BasicBim.IfcGen
    use BasicBim.IfcGen.{runIfcGen, pyImport}


    // pub enum SourceContext
    // pub enum ModelContext

    // // pub type alias Source[a] = IfcGen[SourceContext, a]

    // pub enum ModelCx
    // pub enum ProjectCx

    // pub type alias Model[a] = IfcGen[ModelCx, a]
    // pub type alias Project[a] = IfcGen[ProjectCx, a]

    pub def showPy(m: IfcGen[cx, a]): (String, a) = 
        let (code, _, a) = runIfcGen(1, m);
        let pycode = BasicBim.Base.Syntax.ppCode(code);
        (pycode, a)



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

    // pub def promote(m: IfcGen[cx1, a]): IfcGen[cx2, a] = match m {       
    //     case IfcGen.IfcGen(m1) => IfcGen.IfcGen(m1)
    // }



    pub def model(version: String, _ifcfile: String, body: IfcGen[cx, a]): IfcGen[cx, Unit] = 
        forM (
            _ <- Foldable.forEachM(pyImport, pyimports());
            _model <- BasicBim.API.Project.create_file(version=version);
            _ <- body
        ) yield ()



    // // pub def ifcproject(name: String, body: IfcGen[cx, a]): Project[a] = 
    // //     promote(forM (
    // //         _ <- pyAssign("project", "ifcopenshell.api.root.create_entity(model, ifc_class='IfcProject', name='${name}')");
    // //         ans <- body
    // //     ) yield ans)

    // // pub def unit_add_si_unit(unit_type: {unit_type = String}, prefix: {prefix = String}): Project[IfcSIUnit] = 
    // //     let var = IfcSIUnit.IfcSIUnit("length_units");
    // //     pyAssign2(var, "ifcopenshell.api.unit.add_si_unit(model, unit_type='${unit_type#unit_type}', prefix='${prefix#prefix}')")


}
