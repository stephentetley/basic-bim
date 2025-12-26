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

mod BasicBim {

    use BasicBim.Base.Syntax.Code

    pub enum IfcGen[_cx: Type, a: Type]((Code, Int32) -> (Code, Int32, a))

    instance Functor[IfcGen[cx]] {
        pub def map(f: a -> b \ ef, x: IfcGen[cx, a]): IfcGen[cx, b] \ ef = 
            BasicBim.IfcGen.map(f, x)
    }

    instance Applicative[IfcGen[cx]] {
        pub def point(x: a): IfcGen[cx, a] = 
            BasicBim.IfcGen.point(x)

        pub def ap(f: IfcGen[cx, a -> b \ ef], x: IfcGen[cx, a]): IfcGen[cx, b] \ ef = 
            BasicBim.IfcGen.ap(f, x)
    }

    instance Monad[IfcGen[cx]] {
          pub def flatMap(f: a -> IfcGen[cx, b] \ ef, x: IfcGen[cx, a]): IfcGen[cx, b] \ ef = 
            BasicBim.IfcGen.flatMap(f, x)
    }
}

mod BasicBim.IfcGen {

    use BasicBim.Base.Syntax.{Code, Stmt, Expr, FunArg}

    pub def runIfcGen(st: Int32, f: IfcGen[cx, a]): (Code, Int32, a) = 
        let IfcGen(f1) = f;
        f1(Chain.empty(), st)


    pub def point(x: a): IfcGen[cx, a] = 
        IfcGen((code, i) -> (code, i, x))

    pub def map(f: a -> b \ ef, x: IfcGen[cx, a]): IfcGen[cx, b] \ ef =
        unchecked_cast(IfcGen((code, i) -> 
            let (w, s1, a) = runIfcGen(i, x);
            (Chain.append(code, w), s1, unchecked_cast(f(a) as _ \ {}))
        ) as _ \ ef)

    pub def ap(f: IfcGen[cx, a -> b \ ef], x: IfcGen[cx, a]): IfcGen[cx, b] \ ef =
        unchecked_cast(IfcGen((code, i) -> 
            let (w1, s1, f1) = runIfcGen(i, f);
            let (w2, s2, x1) = runIfcGen(s1, x);
            (Chain.append(Chain.append(code, w1), w2), s2, unchecked_cast(f1(x1) as _ \ {}))
        ) as _ \ ef)

    pub def flatMap(f: a -> IfcGen[cx, b] \ ef, x: IfcGen[cx, a]): IfcGen[cx, b] \ ef =
        unchecked_cast(IfcGen((code, i) -> 
            let (w1, s1, a) = runIfcGen(i, x);
            let f1 = unchecked_cast(f(a) as _ \  {});
            let (w2, s2, b) = runIfcGen(s1, f1);
            (Chain.append(Chain.append(code, w1), w2), s2, b)
        ) as _ \ ef)

    pub def tell(s: Stmt): IfcGen[cx, Unit] \ {} =
        IfcGen((code, i) -> (Chain.snoc(code, s), i, ()))

    pub def freshvar(): IfcGen[cx, Expr] \ {} =
        IfcGen((code, i) -> (code, i+1, Expr.Var("v" + ToString.toString(i))))
    
    pub def pyImport(name: String): IfcGen[cx, Unit] \ {} =
        tell(BasicBim.Base.Syntax.Stmt.Import(name))

    pub def pyInvoke(fname: String, args: List[FunArg]): IfcGen[cx, Unit] \ {} =
        tell(Stmt.ExprStmt(Expr.Apply(Expr.Lit(fname), args)))


    pub def pyAssign(v: Expr, fname: String, args: List[FunArg]): IfcGen[cx, Expr] \ {} =
        forM(
            _ <- tell(Stmt.Assign(v, Expr.Apply(Expr.Lit(fname), args)))
        ) yield v

}
