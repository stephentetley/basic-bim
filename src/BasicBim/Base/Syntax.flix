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


mod BasicBim.Base.Syntax {

    use Text.Pretty
    use Text.PrettyPrint
    use Text.PrettyLevel
    use Text.PrettyPrint.Doc
    use Text.PrettyPrint.{<<>>}
    use Text.PrettyPrint.{empty, int32, squotes, encloseSep, text, char, comma, dot,
        intersperse, lparen, rparen, parens, tupled, commaBrackets, commaBraces, vcat, nest}

    pub type alias Code = Chain[Stmt]

    pub def ppCode(x: Code): String = 
        def step(d: Stmt): String = {
            let txt = Pretty.pPrint(d);
            Text.PrettyPrint.render(80, txt)
        };
        region rc {
            let sb = StringBuilder.empty(rc);
            let _ = Foldable.forEach(s -> { let txt = step(s); StringBuilder.appendLine(txt, sb) }, x);
            StringBuilder.toString(sb)
        }

    pub enum Stmt with ToString {
        case Import(String)
        case Assign(Expr, Expr)
        case ExprStmt(Expr)
    }
    
    instance Pretty[Stmt] {
        pub override def pPrint(x: Stmt): Doc = 
            let stdlevel = Text.prettyNormal();
            match x {
                case Stmt.Import(s)      => text("import") <<>> text(s)
                case Stmt.Assign(e1, e2) => 
                    Pretty.pPrintPrec(stdlevel, 10, e1) <<>> char('=') <<>> Pretty.pPrintPrec(stdlevel, 10, e2)
                case Stmt.ExprStmt(e)    => Pretty.pPrintPrec(stdlevel, 10, e)
            }
    }

    pub enum Expr with ToString {
        case Lit(String)
        case Var(String)
        case Apply(Expr, List[FunArg])
        case ObjApply(Expr, String, List[FunArg])
        case PyList(List[Expr])
        case Dict(List[(String, Expr)])
    }
    
    // Trait for Python literals?

    // pub trait ToLiteral[t] {
    //     pub def toLiteral(x: t): Expr
    // }

    pub def stringLiteral(s: String): Expr = Expr.Lit("'${s}'")
    
    pub def stringLiteralOrNone(x: Option[String]): Expr = match x {
        case Some(s) => stringLiteral(s)
        case None    => Expr.Lit("None")
    }

    pub def stringLiteralNoneWhenEmpty(s: String): Expr = 
        if (s != "") stringLiteral(s) else Expr.Lit("None")


    pub def boolLiteral(b: Bool): Expr = if (b) Expr.Lit("True") else Expr.Lit("False")

    pub def boolLiteralOrNone(b: Option[Bool]): Expr = match b {
        case Some(b1) => boolLiteral(b1)
        case None     => Expr.Lit("None")
    }


    pub def otherLiteral(x: t): Expr with ToString[t] = Expr.Lit(ToString.toString(x))

    
    pub def otherLiteralOrNone(x: Option[t]): Expr with ToString[t] = match x {
        case Some(x1) => otherLiteral(x1)
        case None     => Expr.Lit("None")
    }

    
    pub def listOrNone(xs: List[Expr]): Expr = match xs {
        case Nil  => Expr.Lit("None")
        case _    => Expr.PyList(xs)
    }

    instance Pretty[Expr] {
        pub override def pPrintPrec(d: PrettyLevel, p: Int32, x: Expr): Doc = match x {
            case Expr.Lit(v)            => text(v)
            case Expr.Var(s)            => text(s)
            case Expr.Apply(funE, args) => 
                Pretty.pPrintPrec(d, p, funE) ++ tupled(List.map(Pretty.pPrintPrec(d, p), args))

            case Expr.ObjApply(obj, mname, args) => 
                Pretty.pPrintPrec(d, p, obj) ++ char('.') ++ text(mname) ++ tupled(List.map(Pretty.pPrintPrec(d, p), args))

            case Expr.PyList(xs)        => commaBrackets(List.map(Pretty.pPrintPrec(d, p), xs))
            case Expr.Dict(xs)          => 
                commaBraces(List.map(match ((n,v)) -> squotes(text(n)) ++ char(':') <<>> Pretty.pPrintPrec(d, p, v), xs))
        }
    }

    pub enum FunArg with ToString {
        case Unnamed(Expr)
        case Named(String, Expr)
    }

    instance Pretty[FunArg] {
        pub override def pPrintPrec(d: PrettyLevel, p: Int32, x: FunArg): Doc = match x {
            case FunArg.Unnamed(e)  => Pretty.pPrintPrec(d, p, e)
            case FunArg.Named(n, e) => text(n) ++ char('=') ++ Pretty.pPrintPrec(d, p, e)
        }
    }
}
