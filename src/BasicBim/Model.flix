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

    use BasicBim.{IfcGen}
    use BasicBim.IfcGen.{runIfcGen, pyImport, pyAssign, pyInvoke}

    pub enum SourceContext
    pub enum ModelContext

    // pub type alias Source[a] = IfcGen[SourceContext, a]

    type alias ModelCx = Unit

    pub type alias Model[a] = IfcGen[ModelCx, a]

    pub def showPy(m: Model[a]): (String, a) = 
        let (code, _, a) = runIfcGen((), 1, m);
        let pycode = Foldable.joinWith(x -> x, String.lineSeparator(), code);
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

    pub def model(version: String, ifcfile: String, body: Model[a]): Model[a] = 
        forM(
            _ <- Foldable.forEachM(pyImport, pyimports());
            _ <- pyAssign("model", "ifcopenshell.api.project.create_file(version='${version}')");
            ans <- body;
            _ <- pyInvoke("model.write('${ifcfile}')")
        ) yield ans

}
