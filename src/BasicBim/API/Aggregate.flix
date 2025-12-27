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


mod BasicBim.API.Aggregate {

    use Functor.{<$$>}
    use BasicBim.Base.Syntax.{Expr, FunArg, stringLiteral}
    use BasicBim.{IfcGen}
    use BasicBim.IfcGen.{freshvar, asks, pyAssign}

    // Gets model from context...

    pub def assign_object[r: RecordRow](products: {products = List[String]}, 
                                        relating_object: {relating_object = Expr}): IfcGen[(model = Expr | r), Expr] = 
        def makeArgs(model: Expr) = 
            List#{FunArg.Named("model", model), 
                    FunArg.Named("products", Expr.PyList(List.map(stringLiteral, products#products))),
                    FunArg.Named("relating_object", relating_object#relating_object)};
        forM (
            var <- freshvar();
            args <- asks(cx -> cx#model) <$$> makeArgs;
            ans <- pyAssign(var, "ifcopenshell.api.aggregate.assign_object", args)
        ) yield ans


}
