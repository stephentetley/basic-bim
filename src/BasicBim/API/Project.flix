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


mod BasicBim.API.Project {

    use BasicBim.Base.Syntax.{Expr, FunArg, stringLiteral}
    use BasicBim.{IfcGen}
    use BasicBim.IfcGen.{pyAssign}
    
    pub def create_file(version: {version = String}): IfcGen[cx, Expr] = 
        let args = List#{FunArg.Named("version", stringLiteral(version#version))};
        forM (
            var <- BasicBim.IfcGen.freshvarWithPrefix("model");
            ans <- pyAssign(var, "ifcopenshell.api.project.create_file", args)
        ) yield ans

}
