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


mod BasicBim.API.Context {

    use Functor.{<$$>}
    use BasicBim.Base.Syntax.{Expr, FunArg, stringLiteral}
    use BasicBim.{IfcGen}
    use BasicBim.IfcGen.{freshvar, asks, pyAssign}


   pub def add_context[r: RecordRow](context_type: {context_type = String},
                                    context_identifier: {context_identifier = String},
                                    target_view: {target_view = String},
                                    parent: {parent = Expr}): IfcGen[(model = Expr | r), Expr] = 
        def makeArgs(model) = 
            List#{FunArg.Named("file", model),
                    FunArg.Named("context_type", stringLiteral(context_type#context_type)),
                    FunArg.Named("context_identifier", stringLiteral(context_identifier#context_identifier)),
                    FunArg.Named("target_view", stringLiteral(target_view#target_view)),
                    FunArg.Named("parent", parent#parent)};
        forM (
            var <- freshvar();
            args <- asks(cx -> cx#model) <$$> makeArgs;
            ans <- pyAssign(var, "ifcopenshell.api.context.add_context", args)
        ) yield ans

    
    pub def add_context1[r: RecordRow](context_type: {context_type = String}): IfcGen[(model = Expr | r), Expr] = 
        def makeArgs(model: Expr) = 
            List#{FunArg.Named("file", model),
                    FunArg.Named("context_type", stringLiteral(context_type#context_type))};
        forM (
            var <- freshvar();
            args <- asks(cx -> cx#model) <$$> makeArgs;
            ans <- pyAssign(var, "ifcopenshell.api.context.add_context", args)
        ) yield ans
        
}
