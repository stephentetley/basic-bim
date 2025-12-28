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


mod BasicBim.Pset.Base {

    use BasicBim.Base.Syntax.{Expr}

    // For Pset's we don't want to default to true (or false) 
    // because we have to be careful about generating misleading 
    // information - use `Bool3` with `Unknown` instead
    pub enum Bool3 with ToString, Eq {
        case Yes
        case No
        case Unknown
    }

    pub def toExpr(x: Bool3): Expr = match x {
        case Bool3.Yes      => Expr.Lit("True")
        case Bool3.No       => Expr.Lit("False")
        case Bool3.Unknown  => Expr.Lit("None")
    }

}
