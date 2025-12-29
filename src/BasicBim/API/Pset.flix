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


mod BasicBim.API.Pset {

    use Functor.{<$$>}
    use BasicBim.Base.Syntax.{Expr, FunArg, stringLiteral, stringLiteralOrNone}
    use BasicBim.{IfcGen}
    use BasicBim.IfcGen.{freshvar, asks, pyAssign, pyInvoke}
    
    pub def add_pset[r: RecordRow](product: {product = Expr}, 
                                    name: {name = String}, 
                                    ifc2x3_subclass: {ifc2x3_subclass = Option[String]}): IfcGen[(model = Expr | r), Expr] = 
        def makeArgs(model) = 
            List#{FunArg.Named("file", model), 
                    FunArg.Named("product", product#product), 
                    FunArg.Named("name", stringLiteral(name#name)),
                    FunArg.Named("ifc2x3_subclass", stringLiteralOrNone(ifc2x3_subclass#ifc2x3_subclass))};
        forM (
            var <- BasicBim.IfcGen.freshvarWithPrefix("pset");
            args <- asks(cx -> cx#model) <$$> makeArgs;
            ans <- pyAssign(var, "ifcopenshell.api.pset.add_pset", args)
        ) yield ans
    

    // Note `properties` should be an `Expr.Dict`, i.e. already transformed to Python values
    pub def edit_pset[r: RecordRow](pset: {pset = Expr}, 
                                    properties: {properties = Expr}): IfcGen[(model = Expr| r), Unit] = 
        def makeArgs(model) = 
            List#{FunArg.Named("file", model), 
                    FunArg.Named("pset", pset#pset),
                    FunArg.Named("properties", properties#properties)};
        forM (
            args <- asks(cx -> cx#model) <$$> makeArgs;
            _ <- pyInvoke("ifcopenshell.api.pset.edit_pset", args)
        ) yield ()

}
