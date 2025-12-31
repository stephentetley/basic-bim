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


mod BasicBim.API.Style {

    use Functor.{<$$>}
    use BasicBim.Base.Syntax.{Expr, FunArg, stringLiteral, boolLiteral}
    use BasicBim.{IfcGen}
    use BasicBim.IfcGen.{freshvar, asks, pyAssign}
    
    pub def add_style[r: RecordRow](name: {name = String}, 
                                    ifc_class: {ifc_class = String}): IfcGen[(model = Expr | r), Expr] = 
        def makeArgs(model) = 
            List#{FunArg.Named("file", model),
                    FunArg.Named("name", stringLiteral(name#name)), 
                    FunArg.Named("ifc_class", stringLiteral(ifc_class#ifc_class))};
        forM (
            var <- BasicBim.IfcGen.freshvarWithPrefix("style");
            args <- asks(cx -> cx#model) <$$> makeArgs;
            ans <- pyAssign(var, "ifcopenshell.api.style.add_style", args)
        ) yield ans

    // Note `attributes` should be an `Expr.Dict` , i.e. already transformed to Python values
    pub def add_surface_style[r: RecordRow](style: {style = Expr}, 
                                                    ifc_class: {ifc_class = String},
                                                    attributes: {attributes = Expr}): IfcGen[(model = Expr | r), Expr] = 
        def makeArgs(model) = 
            List#{FunArg.Named("file", model),
                    FunArg.Named("style", style#style), 
                    FunArg.Named("ifc_class", stringLiteral(ifc_class#ifc_class)),
                    FunArg.Named("attributes", attributes#attributes)};
        forM (
            var <- BasicBim.IfcGen.freshvarWithPrefix("sstyle");
            args <- asks(cx -> cx#model) <$$> makeArgs;
            ans <- pyAssign(var, "ifcopenshell.api.style.add_surface_style", args)
        ) yield ans

    pub def assign_representation_styles[r: RecordRow](shape_representation: {shape_representation = Expr}, 
                                                        styles: {styles = List[Expr]},
                                                        replace_previous_same_type_style: {replace_previous_same_type_style = Bool}, 
                                                        should_use_presentation_style_assignment: {should_use_presentation_style_assignment = Bool}): IfcGen[(model = Expr | r), Expr] = 
        def makeArgs(model) = 
            List#{FunArg.Named("file", model),
                    FunArg.Named("shape_representation", shape_representation#shape_representation),
                    FunArg.Named("styles", Expr.PyList(styles#styles)),
                    FunArg.Named("replace_previous_same_type_style", boolLiteral(replace_previous_same_type_style#replace_previous_same_type_style)),
                    FunArg.Named("should_use_presentation_style_assignment", boolLiteral(should_use_presentation_style_assignment#should_use_presentation_style_assignment))};
        forM (
            var <- freshvar();
            args <- asks(cx -> cx#model) <$$> makeArgs;
            ans <- pyAssign(var, "ifcopenshell.api.style.assign_representation_styles", args)
        ) yield ans


}
