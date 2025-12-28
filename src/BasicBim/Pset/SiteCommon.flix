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


mod BasicBim.Pset.SiteCommon {

    use BasicBim.Base.Syntax.{Expr, stringLiteralNoneWhenEmpty, otherLiteralOrNone}
    use BasicBim.Pset.Base
    use BasicBim.Pset.Base.Bool3 


    pub type alias Pset_SiteCommon = {
        buildable_area = Option[Float64],
        site_coverage_ratio = Option[Float64],
        floor_area_ratio = Option[Float64],
        building_height_limit = Option[Float64],
        total_area = Option[Float64]
    }
    
    pub type alias Pset_SiteCommonSetter = Pset_SiteCommon -> Pset_SiteCommon

    def blankPset_SiteCommon(): Pset_SiteCommon = { 
        buildable_area = None,
        site_coverage_ratio = None,
        floor_area_ratio = None,
        building_height_limit = None,
        total_area = None
    }    

    pub def pset_SiteCommon(f: Pset_SiteCommonSetter): Pset_SiteCommon = f(blankPset_SiteCommon())

    pub def toExpr(x: Pset_SiteCommon): Expr = 
        Expr.Dict(List#{
            ("BuildableArea", otherLiteralOrNone(x#buildable_area)),
            ("SiteCoverageRatio", otherLiteralOrNone(x#site_coverage_ratio)),
            ("FloorAreaRatio", otherLiteralOrNone(x#floor_area_ratio)),
            ("BuildingHeightLimit", otherLiteralOrNone(x#building_height_limit)),
            ("TotalArea", otherLiteralOrNone(x#total_area))
        })

}
