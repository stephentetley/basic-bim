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

    // Use state of Map[String, Int32] to allow more meaningful variable names

    pub enum IfcGen[r: RecordRow, a: Type](({| r}, Code, Map[String, Int32]) -> (Code, Map[String, Int32], a))

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

    pub def runIfcGen(ctx: {| r}, st: Map[String, Int32], f: IfcGen[r, a]): (Code, Map[String, Int32], a) = 
        let IfcGen(f1) = f;
        f1(ctx, Chain.empty(), st)


    pub def point(x: a): IfcGen[cx, a] = 
        IfcGen((_, code, i) -> (code, i, x))

    pub def map(f: a -> b \ ef, x: IfcGen[cx, a]): IfcGen[cx, b] \ ef =
        unchecked_cast(IfcGen((cx, code, st) -> 
            let (w, st1, a) = runIfcGen(cx, st, x);
            (Chain.append(code, w), st1, unchecked_cast(f(a) as _ \ {}))
        ) as _ \ ef)

    pub def ap(f: IfcGen[cx, a -> b \ ef], x: IfcGen[cx, a]): IfcGen[cx, b] \ ef =
        unchecked_cast(IfcGen((cx, code, i) -> 
            let (w1, s1, f1) = runIfcGen(cx, i, f);
            let (w2, s2, x1) = runIfcGen(cx, s1, x);
            (Chain.append(Chain.append(code, w1), w2), s2, unchecked_cast(f1(x1) as _ \ {}))
        ) as _ \ ef)

    pub def flatMap(f: a -> IfcGen[cx, b] \ ef, x: IfcGen[cx, a]): IfcGen[cx, b] \ ef =
        unchecked_cast(IfcGen((cx, code, i) -> 
            let (w1, s1, a) = runIfcGen(cx, i, x);
            let f1 = unchecked_cast(f(a) as _ \  {});
            let (w2, s2, b) = runIfcGen(cx, s1, f1);
            (Chain.append(Chain.append(code, w1), w2), s2, b)
        ) as _ \ ef)

    pub def tell(s: Stmt): IfcGen[cx, Unit] \ {} =
        IfcGen((_, code, i) -> (Chain.snoc(code, s), i, ()))

    pub def ask(): IfcGen[cx, {| cx}] \ {} =
        IfcGen((cx, code, i) -> (code, i, cx))

    pub def asks(f: {| r} -> a \ ef): IfcGen[r, a] \ ef =
        unchecked_cast(IfcGen((cx, code, i) -> 
            let ans = unchecked_cast(f(cx) as _ \ {});
            (code, i, ans)
        ) as _ \ ef)


    pub def local(f: {| r} -> {| r1} \ ef, m: IfcGen[r1, a]): IfcGen[r, a] \ ef =
        unchecked_cast(IfcGen((cx, code, i) -> 
            let cx1 = unchecked_cast(f(cx) as _ \ {});
            let (w1, s1, a) = runIfcGen(cx1, i, m);
            (Chain.append(code, w1), s1, a)
        ) as _ \ ef)

    def nextLabel(prefix: String, namescount: Map[String, Int32]): (String, Map[String, Int32]) = 
        match Map.get(prefix, namescount) {
            case Some(i) => ("${prefix}${i}", Map.adjust(x -> x + 1, prefix, namescount))
            case None    => (prefix, Map.insert(prefix, 1, namescount))
        }

    pub def freshvar(): IfcGen[cx, Expr] \ {} = freshvarWithPrefix("v")

    pub def freshvarWithPrefix(prefix: String): IfcGen[cx, Expr] \ {} =
        IfcGen((_, code, st) -> { 
            let (label, st1) = nextLabel(prefix, st);
            (code, st1, Expr.Var(label))
        })
    
    pub def pyImport(name: String): IfcGen[cx, Unit] \ {} =
        tell(BasicBim.Base.Syntax.Stmt.Import(name))

    pub def pyInvoke(fname: String, args: List[FunArg]): IfcGen[cx, Unit] \ {} =
        tell(Stmt.ExprStmt(Expr.Apply(Expr.Lit(fname), args)))

    pub def pyObjInvoke(obj: Expr, mname: String, args: List[FunArg]): IfcGen[cx, Unit] \ {} =
        tell(Stmt.ExprStmt(Expr.ObjApply(obj, mname, args)))

    pub def pyAssign(v: Expr, fname: String, args: List[FunArg]): IfcGen[cx, Expr] \ {} =
        forM(
            _ <- tell(Stmt.Assign(v, Expr.Apply(Expr.Lit(fname), args)))
        ) yield v

    pub def verbatim(s: String): IfcGen[cx, Unit] \ {} =
        tell(Stmt.Verbatim(String.lines(s)))


    pub def pyComment(s: String): IfcGen[cx, Unit] \ {} =
        let xs = String.lines(s) |> List.map(String.concat("# "));
        tell(Stmt.Verbatim(xs))

}
