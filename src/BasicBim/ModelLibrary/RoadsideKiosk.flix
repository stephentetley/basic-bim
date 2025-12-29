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


mod BasicBim.ModelLibrary.RoadsideKiosk {

    use BasicBim.IfcGen
    use BasicBim.Base.Syntax.{Expr}
    use BasicBim.Model
    use BasicBim.Model.{ifcBuilding, ifcBuildingStorey, getColour}


    // TODO - shading style should be lifted out so it can be defined just once...
    pub def roadsideKiosk(name: String): IfcGen[(model = Expr, ifcproject = Expr, ifcsite = Expr | r), Unit] = 
        ifcBuilding(name, forM (
            _style <- Model.ifcSurfaceStyleShading("RKiosk Shading Style", BasicBim.Colour.NamedColours.darkseagreen(), 0.1f64);
            _ <- ifcBuildingStorey("${name} Storey1", forM (
                    
                    _ <- Applicative.point("todo")
                    ) yield())
        ) yield ())

}
