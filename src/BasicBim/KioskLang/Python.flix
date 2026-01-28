/*
 * Copyright 2026 Stephen Tetley
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


mod BasicBim.KioskLang.Python {

    use Text.Pretty
    use Text.PrettyPrint
    use Text.PrettyLevel
    use Text.PrettyPrint.Doc
    use Text.PrettyPrint.{<<>>, <^>, <!>}
    use Text.PrettyPrint.{empty, int64, float64, squotes, encloseSep, text, char, comma, dot,
        intersperse, lparen, rparen, parens, tupled, vcat, nest}


    pub type alias ID = String


    pub enum Literal with Eq, ToString {
        case PyNone
        case PyTrue
        case PyFalse
        case PyInteger(Int64)
        case PyDouble(Float64)
        case PyString(String)
    }

    instance Pretty[Literal] {
        pub override def pPrint(x: Literal): Doc = match x {
            case Literal.PyNone         => text("None")
            case Literal.PyTrue         => text("True")
            case Literal.PyFalse        => text("False")
            case Literal.PyInteger(i)   => int64(i)
            case Literal.PyDouble(d)    => float64(d)
            case Literal.PyString(s)    => squotes(text(s))
        }
    }


    pub enum Expr with Eq, ToString {
        case CExpr(CExpr)
    }


    instance Pretty[Expr] {
        pub override def pPrintPrec(d: PrettyLevel, p: Int32, x: Expr): Doc = match x {
            case Expr.CExpr(e) => Pretty.pPrintPrec(d, p, e)
        }
    }


    pub enum CExpr with Eq, ToString {
        case Ident(ID)
        case Literal(Literal)
        case CallExpr(ID, List[FunArg])
    }

    instance Pretty[CExpr] {
        pub override def pPrintPrec(d: PrettyLevel, p: Int32, x: CExpr): Doc = match x {
            case CExpr.Ident(s)             => text(s)
            case CExpr.Literal(lit)         => Pretty.pPrint(lit)
            case CExpr.CallExpr(name, args) =>
                text(name) ++ tupled(List.map(e -> Pretty.pPrintPrec(d, p, e), args)) 

        }
    }

    pub enum FunArg with Eq, ToString {
        case Unnamed(Expr)
        case Named(ID, Expr)
    }
    
    instance Pretty[FunArg] {
        pub override def pPrintPrec(d: PrettyLevel, p: Int32, x: FunArg): Doc = match x {
            case FunArg.Unnamed(e)      => Pretty.pPrintPrec(d, p, e)
            case FunArg.Named(name, e)  =>
                text(name) ++ char('=') ++ Pretty.pPrintPrec(d, p, e)
        }
    }

}

