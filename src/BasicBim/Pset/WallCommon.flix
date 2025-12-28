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


mod BasicBim.Pset.WallCommon {

    use BasicBim.Base.Syntax.{Expr, stringLiteralNoneWhenEmpty, otherLiteralOrNone}
    use BasicBim.Pset.Base
    use BasicBim.Pset.Base.Bool3 

    // User can avoid specifying all properties by updating a "blank" record:
    // let r = {status = "NEW" | Pset.WallCommon.pset_WallCommon()};
    // Going one step further we can use an updater function
    // and not expose the blank record - `x -> {status = "NEW" | x}`


    pub type alias Pset_WallCommon = {
        status = String,
        acoustic_rating = String,
        fire_rating = String,
        combustible = Bool3,
        surface_spread_of_flame = String,
        thermal_transmittance = Option[Float64],
        is_external = Bool3,
        load_bearing = Bool3,
        extend_to_structure = Bool3,
        compartmentation = Bool3
    }
    
    pub type alias Pset_WallCommonSetter = Pset_WallCommon -> Pset_WallCommon

    def blankPset_WallCommon(): Pset_WallCommon = { 
        status = "NOTKNOWN",
        acoustic_rating = "",
        fire_rating = "",
        combustible = Bool3.Unknown,
        surface_spread_of_flame = "",
        thermal_transmittance = None,
        is_external = Bool3.Unknown,
        load_bearing = Bool3.Unknown,
        extend_to_structure = Bool3.Unknown,
        compartmentation = Bool3.Unknown
    }    

    pub def pset_WallCommon(f: Pset_WallCommonSetter): Pset_WallCommon = f(blankPset_WallCommon())

    pub def toExpr(x: Pset_WallCommon): Expr = 
        Expr.Dict(List#{
            ("Status", stringLiteralNoneWhenEmpty(x#status)),
            ("AcousticRating", stringLiteralNoneWhenEmpty(x#acoustic_rating)),
            ("FireRating", stringLiteralNoneWhenEmpty(x#fire_rating)),
            ("Combustible", Base.toExpr(x#combustible)),
            ("SurfaceSpreadOfFlame", stringLiteralNoneWhenEmpty(x#surface_spread_of_flame)),
            ("ThermalTransmittance", otherLiteralOrNone(x#thermal_transmittance)),
            ("IsExternal", Base.toExpr(x#is_external)),
            ("LoadBearing", Base.toExpr(x#load_bearing)),
            ("ExtendToStructure", Base.toExpr(x#extend_to_structure)),
            ("Compartmentation", Base.toExpr(x#compartmentation))
        })

}
