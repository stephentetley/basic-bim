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

mod Test01 {

    use BasicBim.IfcGen
    use BasicBim.Model.{model, ifcProject}

    @test
    def test01(): Unit \ IO = 
        let (py, _) = BasicBim.Model.writePy("./test/output/basic_bim01.py",{}, 
            model("IFC4X3", "./output/basic_bim01.ifc", 
                ifcProject("Addley West Project", forM(
                    si_len  <- BasicBim.API.Unit.add_si_unit(unit_type = "LENGTHUNIT", prefix="MILLI");
                    si_area <- BasicBim.API.Unit.add_si_unit(unit_type = "AREAUNIT", prefix="");
                    _       <- BasicBim.API.Unit.assign_unit(units= List#{si_len, si_area});
                    p1      <- BasicBim.API.Owner.add_person(identification="tetleys", family_name="Tetley", given_name="Stephen");
                    _       <- BasicBim.API.Owner.add_application(application_developer=p1, version="0.0.1", application_full_name="basic-bim", application_identifier="basic-bim");
                    rcx     <- BasicBim.API.Context.add_context1(context_type="Model");
                    _bcx    <- BasicBim.API.Context.add_context(context_type="Model", context_identifier="Body", target_view="MODEL_VIEW", parent=rcx);
                    ans     <- Applicative.point("Done")
                ) yield ans)));
        println(py);
        ()


}