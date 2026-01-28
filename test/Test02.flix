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

mod Test02 {

    use BasicBim.KioskLang.Syntax.{V2, V3, Shape}
    use BasicBim.KioskLang.Python.{Expr, CExpr}
    
    @test
    def test01(): Unit \ IO = 
        let wall1 = Shape.Wall({length_m = 2.0f64, height_m = 1.6f64, thickness_m=0.05f64});
        println(wall1);
        ()

    @test
    def test02(): Unit \ IO = 
        let py = CExpr.CallExpr("ifcopenshell.api.geometry.add_wall_representation", 
                                List#{});
        let doc = Text.Pretty.pPrint(py);
        println(ToString.toString(doc));
        ()

}
