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


mod BasicBim.API.Obj.File {

    use Functor.{<$$>}
    use BasicBim.Base.Syntax.{Expr, FunArg, stringLiteral, boolLiteral}
    use BasicBim.{IfcGen}
    use BasicBim.IfcGen.{asks, pyObjInvoke}
    
    pub def write[r: RecordRow](path: {path = String}, 
                                format: {format = String}, 
                                zipped: {zipped = Bool}): IfcGen[(model = Expr | r), Unit] = 
        def makeArgs() = 
            List#{FunArg.Named("path", stringLiteral(path#path)),
                    FunArg.Named("format", stringLiteral(format#format)),
                    FunArg.Named("zipped", boolLiteral(zipped#zipped))};
        forM (
            model <- asks(cx -> cx#model);
            _ <- pyObjInvoke(model, "write", makeArgs())
        ) yield ()

}
