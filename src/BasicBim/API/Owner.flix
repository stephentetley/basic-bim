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


mod BasicBim.API.Owner {

    use Functor.{<$$>}
    use BasicBim.Base.Syntax.{Expr, FunArg, stringLiteral}
    use BasicBim.{IfcGen}
    use BasicBim.IfcGen.{freshvar, asks, pyAssign}
    

    pub def add_application[r: RecordRow](application_developer: {application_developer = Expr},
                                            version: {version = String},                                             
                                            application_full_name: {application_full_name = String},
                                            application_identifier: {application_identifier = String}): IfcGen[(model = Expr | r), Expr] = 
        def makeArgs(model) = 
            List#{FunArg.Named("file", model),
                    FunArg.Named("application_developer", application_developer#application_developer), 
                    FunArg.Named("version", stringLiteral(version#version)),
                    FunArg.Named("application_full_name", stringLiteral(application_full_name#application_full_name)),
                    FunArg.Named("application_identifier", stringLiteral(application_identifier#application_identifier))};
        forM (
            var <- BasicBim.IfcGen.freshvarWithPrefix("app");
            args <- asks(cx -> cx#model) <$$> makeArgs;
            ans <- pyAssign(var, "ifcopenshell.api.owner.add_application", args)
        ) yield ans


    pub def add_organisation[r: RecordRow](identification: {identification = String}, 
                                            name: {name = String}): IfcGen[(model = Expr | r), Expr] = 
        def makeArgs(model) = 
            List#{FunArg.Named("file", model),
                    FunArg.Named("identification", stringLiteral(identification#identification)), 
                    FunArg.Named("name", stringLiteral(name#name))};
        forM (
            var <- BasicBim.IfcGen.freshvarWithPrefix("org");
            args <- asks(cx -> cx#model) <$$> makeArgs;
            ans <- pyAssign(var, "ifcopenshell.api.owner.add_organisation", args)
        ) yield ans

    pub def add_person[r: RecordRow](identification: {identification = String}, 
                                    family_name: {family_name = String},
                                    given_name: {given_name = String}): IfcGen[(model = Expr | r), Expr] = 
        def makeArgs(model) = 
            List#{FunArg.Named("file", model),
                    FunArg.Named("identification", stringLiteral(identification#identification)), 
                    FunArg.Named("family_name", stringLiteral(family_name#family_name)),
                    FunArg.Named("given_name", stringLiteral(given_name#given_name))};
        forM (
            var <- BasicBim.IfcGen.freshvarWithPrefix("person");
            args <- asks(cx -> cx#model) <$$> makeArgs;
            ans <- pyAssign(var, "ifcopenshell.api.owner.add_person", args)
        ) yield ans

}
