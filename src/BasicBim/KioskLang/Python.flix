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
        case NotExpr(Expr)
        case AndExpr(Expr, Expr)
        case OrExpr(Expr, Expr)
        case IfElseExpr(Expr, Expr, Expr)
    }


    instance Pretty[Expr] {
        pub override def pPrintPrec(d: PrettyLevel, p: Int32, x: Expr): Doc = match x {
            case Expr.CExpr(e)                  => Pretty.pPrintPrec(d, p, e)
            case Expr.NotExpr(e)                => text("not") ++ Pretty.pPrintPrec(d, p, e)
            case Expr.AndExpr(e1, e2)           => 
                Pretty.pPrintPrec(d, p, e1) ++ text("and") ++ Pretty.pPrintPrec(d, p, e2)
            
            case Expr.OrExpr(e1, e2)            => 
                Pretty.pPrintPrec(d, p, e1) ++ text("or") ++ Pretty.pPrintPrec(d, p, e2)

            case Expr.IfElseExpr(e1, e2, e3)    => 
                Pretty.pPrintPrec(d, p, e1) 
                    ++ text("if") ++ Pretty.pPrintPrec(d, p, e2)
                    ++ text("else") ++ Pretty.pPrintPrec(d, p, e3)
        }
    }


    pub enum CExpr with Eq, ToString {
        case Ident(ID)
        case Literal(Literal)
        case CallExpr(ID, List[FunArg])
        case BinExpr(CExpr, BinOp, CExpr)
    }

    instance Pretty[CExpr] {
        pub override def pPrintPrec(d: PrettyLevel, p: Int32, x: CExpr): Doc = match x {
            case CExpr.Ident(s)             => text(s)
            case CExpr.Literal(lit)         => Pretty.pPrint(lit)
            case CExpr.CallExpr(name, args) =>
                text(name) ++ tupled(List.map(e -> Pretty.pPrintPrec(d, p, e), args)) 

            case CExpr.BinExpr(e1, op, e2)  =>
                Pretty.pPrintPrec(d, p, e1) ++ Pretty.pPrint(op) ++ Pretty.pPrintPrec(d, p, e2)

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

    pub enum BinOp with Eq, ToString { 
        case Plus
        case Minus
        case Mult
        case Divide
        case Mod
        case Equal
        case NotEqual
        case LtEqual
        case GtEqual
        case LessThan
        case GreaterThan
        case Is
    }

    instance Pretty[BinOp] {
        pub override def pPrint(x: BinOp): Doc = match x {
            case BinOp.Plus             => char('+')
            case BinOp.Minus            => char('-')
            case BinOp.Mult             => char('*')
            case BinOp.Divide           => text("//")
            case BinOp.Mod              => char('%')
            case BinOp.Equal            => text("==")
            case BinOp.NotEqual         => text("!=")
            case BinOp.LtEqual          => text("<=")
            case BinOp.GtEqual          => text(">=")
            case BinOp.LessThan         => char('<')
            case BinOp.GreaterThan      => char('>')
            case BinOp.Is               => text("is")
        }
    }

    pub enum MemberExpr with Eq, ToString {
        case Member(CExpr, ID)
    }

    instance Pretty[MemberExpr] {
        pub override def pPrintPrec(d: PrettyLevel, p: Int32, x: MemberExpr): Doc = match x {
            case MemberExpr.Member(e, ident)    => 
                Pretty.pPrintPrec(d, p, e) <<>> char('.') <<>> text(ident)
        }
    }


}

