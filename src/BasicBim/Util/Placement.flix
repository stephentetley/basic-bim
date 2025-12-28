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


mod BasicBim.Util.Placement {

    use Functor.{<$$>}
    use BasicBim.Base.Syntax.{Expr, FunArg, stringLiteral, otherLiteral}
    use BasicBim.{IfcGen}
    use BasicBim.IfcGen.{freshvar, asks, pyAssign}
    
    pub def rotation(angle: {angle = Float64}, axis: {axis = String}): IfcGen[cx, Expr] = 
        def makeArgs() = 
            List#{FunArg.Named("angle", otherLiteral(angle#angle)),
                    FunArg.Named("axis", stringLiteral(axis#axis))};
        forM (
            var <- freshvar();
            ans <- pyAssign(var, "ifcopenshell.util.placemenet.rotation", makeArgs())
        ) yield ans

}
