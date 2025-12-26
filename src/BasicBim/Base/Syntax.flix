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
    use Text.PrettyPrint.{<<>>, <^>, <!>}
    use Text.PrettyPrint.{empty, int32, squotes, encloseSep, text, char, comma, dot,
        intersperse, lparen, rparen, parens, tupled, vcat, nest}


    pub type alias Code = Chain[Stmt]

    pub def ppCode(x: Code): String = 
        region rc { 
            let sb = StringBuilder.empty(rc);
            let _ = Foldable.forEach(s -> 
                { let txt = Pretty.pPrint(s) |> Text.PrettyPrint.render(80); 
                  StringBuilder.appendLine(txt, sb) }, x);
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
    }
    
    instance Pretty[Expr] {
        pub override def pPrintPrec(d: PrettyLevel, p: Int32, x: Expr): Doc = match x {
            case Expr.Lit(v)            => text(v)
            case Expr.Var(s)            => text(s)
            case Expr.Apply(funE, args) => 
                Pretty.pPrintPrec(d, p, funE) ++ tupled(List.map(Pretty.pPrintPrec(d, p), args))
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
