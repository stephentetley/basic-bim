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


mod BasicBim.API.Spatial {

    use Functor.{<$$>}
    use BasicBim.Base.Syntax.{Expr, FunArg, stringLiteral}
    use BasicBim.{IfcGen}
    use BasicBim.IfcGen.{freshvar, asks, pyAssign}
    
    pub def assign_container[r: RecordRow](products: {products = List[Expr]}, 
                                            relating_structure: {relating_structure = Expr}): IfcGen[(model = Expr | r), Expr] = 
        def makeArgs(model) = 
            List#{FunArg.Named("file", model),
                    FunArg.Named("products", Expr.PyList(products#products)), 
                    FunArg.Named("relating_structure", relating_structure#relating_structure)};
        forM (
            var <- freshvar();
            args <- asks(cx -> cx#model) <$$> makeArgs;
            ans <- pyAssign(var, "ifcopenshell.api.spatial.assign_container", args)
        ) yield ans


}
