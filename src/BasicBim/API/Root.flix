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





mod BasicBim.API.Root {

    use BasicBim.Base.Syntax.{Expr, FunArg, stringLiteral}
    use BasicBim.{IfcGen}
    use BasicBim.IfcGen.{freshvar, pyAssign}
    
    pub def create_entity(ifc_class: {ifc_class = String}, name: {name = String}): IfcGen[cx, Expr] = 
        let args = List#{FunArg.Unnamed(Expr.Var("model")), 
                        FunArg.Named("ifc_class", stringLiteral(ifc_class#ifc_class)), 
                        FunArg.Named("name", stringLiteral(name#name))};
        forM (
            var <- freshvar();
            ans <- pyAssign(var, "ifcopenshell.api.root.create_entity", args)
        ) yield ans


}
