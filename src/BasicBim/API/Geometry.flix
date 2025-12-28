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


mod BasicBim.API.Geometry {

    use Functor.{<$$>}
    use BasicBim.Base.Syntax.{Expr, FunArg, stringLiteral, otherLiteral, otherLiteralOrNone,
                                boolLiteral, listOrNone}
    use BasicBim.{IfcGen}
    use BasicBim.IfcGen.{freshvar, asks, pyAssign}
    
    pub def add_wall_representation[r: RecordRow](context: {context = Expr}, 
                                                    length: {length = Float64}, 
                                                    height: {height = Float64},
                                                    direction_sense: {direction_sense = String}, 
                                                    offset: {offset = Option[Float64]}, 
                                                    thickness: {thickness = Float64},
                                                    x_angle: {x_angle = Option[Float64]},
                                                    clippings: {clippings = List[Expr]},
                                                    booleans: {booleans = List[Expr]}): IfcGen[(model = Expr | r), Expr] = 
        def makeArgs(model) = 
            List#{FunArg.Named("file", model),
                    FunArg.Named("context", context#context), 
                    FunArg.Named("length", otherLiteral(length#length)), 
                    FunArg.Named("height", otherLiteral(height#height)), 
                    FunArg.Named("direction_sense", stringLiteral(direction_sense#direction_sense)), 
                    FunArg.Named("offset", otherLiteralOrNone(offset#offset)), 
                    FunArg.Named("thickness", otherLiteral(thickness#thickness)), 
                    FunArg.Named("x_angle", otherLiteralOrNone(x_angle#x_angle)), 
                    FunArg.Named("clippings", listOrNone(clippings#clippings)), 
                    FunArg.Named("booleans", listOrNone(booleans#booleans))};
        forM (
            var <- freshvar();
            args <- asks(cx -> cx#model) <$$> makeArgs;
            ans <- pyAssign(var, "ifcopenshell.api.geometry.add_wall_representation", args)
        ) yield ans

    pub def assign_representation[r: RecordRow](product: {product = Expr}, 
                                                representation: {representation = Expr}): IfcGen[(model = Expr | r), Expr] = 
        def makeArgs(model) = 
            List#{FunArg.Named("file", model),
                    FunArg.Named("product", product#product), 
                    FunArg.Named("representation", representation#representation)};
        forM (
            var <- freshvar();
            args <- asks(cx -> cx#model) <$$> makeArgs;
            ans <- pyAssign(var, "ifcopenshell.api.geometry.assign_representation", args)
        ) yield ans

    pub def connect_path[r: RecordRow](relating_element: {relating_element = Expr}, 
                                        related_element: {related_element = Expr},
                                        relating_connection: {relating_connection = String},
                                        related_connection: {related_connection = String}, 
                                        description: {description = String}): IfcGen[(model = Expr | r), Expr] = 
        def makeArgs(model) = 
            List#{FunArg.Named("file", model),
                    FunArg.Named("relating_element", relating_element#relating_element), 
                    FunArg.Named("related_element", related_element#related_element), 
                    FunArg.Named("relating_connection", stringLiteral(relating_connection#relating_connection)), 
                    FunArg.Named("related_connection", stringLiteral(related_connection#related_connection)), 
                    FunArg.Named("description", stringLiteral(description#description))};
        forM (
            var <- freshvar();
            args <- asks(cx -> cx#model) <$$> makeArgs;
            ans <- pyAssign(var, "ifcopenshell.api.geometry.connect_path", args)
        ) yield ans


    pub def edit_object_placement[r: RecordRow](product: {product = Expr}, 
                                                matrix: {matrix = Expr}, 
                                                is_si: {is_si = Bool}, 
                                                should_transform_children: {should_transform_children = Bool}): IfcGen[(model = Expr | r), Expr] = 
        def makeArgs(model) = 
            List#{FunArg.Named("file", model),
                    FunArg.Named("product", product#product), 
                    FunArg.Named("matrix", matrix#matrix), 
                    FunArg.Named("is_si", boolLiteral(is_si#is_si)), 
                    FunArg.Named("should_transform_children", boolLiteral(should_transform_children#should_transform_children))};
        forM (
            var <- freshvar();
            args <- asks(cx -> cx#model) <$$> makeArgs;
            ans <- pyAssign(var, "ifcopenshell.api.geometry.edit_object_placement", args)
        ) yield ans


}
