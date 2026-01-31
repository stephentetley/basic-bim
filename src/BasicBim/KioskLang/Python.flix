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
        intersperse, lparen, rparen, parens, brackets, tupled, commaBrackets, vcat, hsep, nest}

    // Python syntax based on ChocoPy

    pub type alias ID = String

    def pID(s: ID): Doc = text(s)

    pub enum IDSTRING with Eq,ToString {
        case IDSTRING(String)
    }
    
    instance Pretty[IDSTRING] {
        pub override def pPrint(x: IDSTRING): Doc = match x {
            case IDSTRING.IDSTRING(s) => text(s)
        }
    }


    pub enum Program with Eq, ToString {
        case Program(List[ProgramDef], List[Stmt])
    }

    instance Pretty[Program] {
        pub override def pPrint(x: Program): Doc = match x {
            case Program.Program(defs, stmts) => 
                vcat(List.map(Pretty.pPrint, defs)) <!> vcat(List.map(Pretty.pPrint, stmts))
        }
    }

    pub enum ProgramDef with Eq, ToString {
        case ProgramVarDef(VarDef)
        case ProgramFuncDef(FuncDef)
        case ProgramClassDef(ClassDef)
    }

    instance Pretty[ProgramDef] {
        pub override def pPrint(x: ProgramDef): Doc = match x {
            case ProgramDef.ProgramVarDef(vdef)     => Pretty.pPrint(vdef)
            case ProgramDef.ProgramFuncDef(fdef)    => Pretty.pPrint(fdef)
            case ProgramDef.ProgramClassDef(cdef)   => Pretty.pPrint(cdef)
        }
    }

    pub enum ClassDef with Eq, ToString {
        case ClassDef(ID, ID, ClassBody)
    }

    instance Pretty[ClassDef] {
        pub override def pPrint(x: ClassDef): Doc = match x {
            case ClassDef.ClassDef(ident, superid, body) => {
                text("def") <<>> pID(ident) ++ parens(pID(superid)) ++ char(':')
                    <!> Pretty.pPrint(body)
            }
        }
    }


    pub enum ClassBody with Eq, ToString {
        case Pass
        case BodyDefs(Nel[ClassBodyDef])
    }

    instance Pretty[ClassBody] {
        pub override def pPrint(x: ClassBody): Doc = match x {
            case ClassBody.Pass             => text("pass")
            case ClassBody.BodyDefs(defs)   => {
                let defs1 = Nel.toList(defs);
                vcat(List.map(Pretty.pPrint, defs1))
            }
        }
    }


    pub enum ClassBodyDef with Eq, ToString {
        case ClassVarDef(VarDef)
        case ClassFuncDef(FuncDef)
    }

    instance Pretty[ClassBodyDef] {
        pub override def pPrint(x: ClassBodyDef): Doc = match x {
            case ClassBodyDef.ClassVarDef(vdef)     => Pretty.pPrint(vdef)
            case ClassBodyDef.ClassFuncDef(fdef)    => Pretty.pPrint(fdef)
        }
    }

    pub enum FuncDef with Eq, ToString {
        case FuncDef(ID, List[TypedVar], Option[Type], FuncBody)
    }

    instance Pretty[FuncDef] {
        pub override def pPrint(x: FuncDef): Doc = match x {
            case FuncDef.FuncDef(ident, args, otype, body) => {
                let returntype = match otype {
                    case None       => empty()
                    case Some(ty)   => text(" ->") <<>> Pretty.pPrint(ty)
                };
                text("def") <<>> pID(ident) 
                    ++ tupled(List.map(Pretty.pPrint, args)) ++ returntype
                    ++ char(':')
                    <!> Pretty.pPrint(body)
            }
        }
    }

    pub enum FuncBody with Eq, ToString {
        case FuncBody(List[FuncBodyDecl], Nel[Stmt])
    }

    instance Pretty[FuncBody] {
        pub override def pPrint(x: FuncBody): Doc = match x {
            case FuncBody.FuncBody(decls, stmts) => {
                let stmts1 = Nel.toList(stmts);
                vcat(List.map(Pretty.pPrint, decls)) <!> vcat(List.map(Pretty.pPrint, stmts1)) 
            }
        }
    }


    pub enum FuncBodyDecl with Eq, ToString {
        case FuncGlobalDecl(GlobalDecl)
        case FuncNonLocalDecl(NonLocalDecl)
        case FuncVarDef(VarDef)
        case FuncFuncDef(FuncDef)
    }

    instance Pretty[FuncBodyDecl] {
        pub override def pPrint(x: FuncBodyDecl): Doc = match x {
            case FuncBodyDecl.FuncGlobalDecl(decl)      => Pretty.pPrint(decl)
            case FuncBodyDecl.FuncNonLocalDecl(decl)    => Pretty.pPrint(decl)
            case FuncBodyDecl.FuncVarDef(vdef)          => Pretty.pPrint(vdef)
            case FuncBodyDecl.FuncFuncDef(fdef)         => Pretty.pPrint(fdef)
        }
    }

    pub enum TypedVar with Eq, ToString {
        case TypedVar(ID, Type)
    }
    
    instance Pretty[TypedVar] {
        pub override def pPrint(x: TypedVar): Doc = match x {
            case TypedVar.TypedVar(s, ty) => pID(s) <<>> char(':') <<>> Pretty.pPrint(ty)
        }
    }

    pub enum Type with Eq, ToString {
        case ClassType(IDSTRING)
        case ListType(Type)
    }
    
    instance Pretty[Type] {
        pub override def pPrint(x: Type): Doc = match x {
            case Type.ClassType(s) => Pretty.pPrint(s)
            case Type.ListType(t)  => brackets(Pretty.pPrint(t))
        }
    }


    pub enum GlobalDecl with Eq, ToString {
        case Global(ID)
    }

    instance Pretty[GlobalDecl] {
        pub override def pPrint(x: GlobalDecl): Doc = match x {
            case GlobalDecl.Global(ident) => text("nonlocal") <<>> pID(ident)
        }
    }

    pub enum NonLocalDecl with Eq, ToString {
        case NonLocal(ID)
    }

    instance Pretty[NonLocalDecl] {
        pub override def pPrint(x: NonLocalDecl): Doc = match x {
            case NonLocalDecl.NonLocal(ident) => text("nonlocal") <<>> pID(ident)
        }
    }

    pub enum VarDef with Eq, ToString {
        case VarDef(TypedVar, Literal)
    }

    instance Pretty[VarDef] {
        pub override def pPrint(x: VarDef): Doc = match x {
            case VarDef.VarDef(v, lit) => Pretty.pPrint(v) <<>> char('=') <<>> Pretty.pPrint(lit)
        }
    }

    pub enum Stmt with Eq, ToString {
        case SimpleStmt(SimpleStmt)
        case IfStmt(Expr, Block, List[(Expr, Block)], Option[Block])
        case While(Expr, Block)
        case ForIn(ID, Expr, Block)
    }
    
    instance Pretty[Stmt] {
        pub override def pPrintPrec(d: PrettyLevel, p: Int32, x: Stmt): Doc = match x {
            case Stmt.SimpleStmt(stmt)              => Pretty.pPrintPrec(d, p, stmt)
            case Stmt.IfStmt(e, blk, elifs, oelse)  => {
                let elifs1 = List.map(match((e1, blk1)) -> text("elif") <<>> Pretty.pPrintPrec(d, p, e1) ++ char(':') <<>> Pretty.pPrint(blk1), elifs);
                let oelse1 = match oelse {
                    case None       => Nil
                    case Some(blk1) => List#{text("else") ++ char(':') <<>> Pretty.pPrint(blk1)}
                };
                text("if") <<>> Pretty.pPrintPrec(d, p, e) ++ char(':')
                    <<>> Pretty.pPrint(blk)
                    <!> vcat(elifs1 ::: oelse1)
            }
            
            case Stmt.While(e, blk)                 => 
                text("while") <<>> Pretty.pPrintPrec(d, p, e) <<>> char(':') <<>> Pretty.pPrint(blk)
            
            case Stmt.ForIn(s, e, blk)              => 
                text("for") <<>> pID(s) <<>> text("in") 
                    <<>> Pretty.pPrintPrec(d, p, e) <<>> char(':') <<>> Pretty.pPrint(blk)
        }
    }


    pub enum SimpleStmt with Eq, ToString {
        case Pass 
        case ExprStmt(Expr)
        case Return(Option[Expr])
        case Assign(Nel[Target], Expr)
    }
    
    instance Pretty[SimpleStmt] {
        pub override def pPrintPrec(d: PrettyLevel, p: Int32, x: SimpleStmt): Doc = match x {
            case SimpleStmt.Pass            => text("pass")
            case SimpleStmt.ExprStmt(e)     => Pretty.pPrintPrec(d, p, e)
            case SimpleStmt.Return(None)    => text("return")
            case SimpleStmt.Return(Some(e)) => text("return") ++ Pretty.pPrintPrec(d, p, e)
            case SimpleStmt.Assign(ts, e)   => {
                let ts1 = Nel.toList(ts);
                hsep(List.map(t -> Pretty.pPrintPrec(d, p, t) ++ char('='), ts1)) ++ Pretty.pPrintPrec(d, p, e)
            }
        }
    }

    pub enum Block with Eq, ToString {
        case Block(Nel[Stmt])
    }

    // todo INDENT
    instance Pretty[Block] {
        pub override def pPrint(x: Block): Doc = match x {
            case Block.Block(xs) => {
                let xs1 = Nel.toList(xs);
                vcat(List.map(Pretty.pPrint, xs1))
            }
        }
    }

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
        case ListExpr(List[Expr])
        case MemberExpr(MemberExpr)
        case IndexExpr(IndexExpr)
        case MemberCallExpr(MemberExpr, List[FunArg])
        case CallExpr(ID, List[FunArg])
        case BinExpr(CExpr, BinOp, CExpr)
        case NegateExpr(CExpr)
    }

    instance Pretty[CExpr] {
        pub override def pPrintPrec(d: PrettyLevel, p: Int32, x: CExpr): Doc = match x {
            case CExpr.Ident(s)                 => pID(s)
            case CExpr.Literal(lit)             => Pretty.pPrint(lit)
            case CExpr.ListExpr(es)             =>
                commaBrackets(List.map(e1 -> Pretty.pPrintPrec(d, p, e1), es))

            case CExpr.MemberExpr(e)            => Pretty.pPrintPrec(d, p, e)
            case CExpr.IndexExpr(e)             => Pretty.pPrintPrec(d, p, e)
            case CExpr.MemberCallExpr(e, args)  =>
                Pretty.pPrintPrec(d, p, e) ++ tupled(List.map(e1 -> Pretty.pPrintPrec(d, p, e1), args)) 

            case CExpr.CallExpr(name, args)     =>
                text(name) ++ tupled(List.map(e -> Pretty.pPrintPrec(d, p, e), args)) 

            case CExpr.BinExpr(e1, op, e2)      =>
                Pretty.pPrintPrec(d, p, e1) ++ Pretty.pPrint(op) ++ Pretty.pPrintPrec(d, p, e2)

            case CExpr.NegateExpr(e)            => char('-') ++ Pretty.pPrintPrec(d, p, e)
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


    pub enum IndexExpr with Eq, ToString {
        case Index(CExpr, Expr)
    }

    instance Pretty[IndexExpr] {
        pub override def pPrintPrec(d: PrettyLevel, p: Int32, x: IndexExpr): Doc = match x {
            case IndexExpr.Index(e1, e2)    => 
                Pretty.pPrintPrec(d, p, e1) 
                    <<>> char('[') <<>> Pretty.pPrintPrec(d, p, e2) <<>> char(']')
        }
    }

    pub enum Target with Eq, ToString {
        case TargetID(ID)
        case TargetMember(MemberExpr)
        case TargetIndex(IndexExpr)
    }

    instance Pretty[Target] {
        pub override def pPrintPrec(d: PrettyLevel, p: Int32, x: Target): Doc = match x {
            case Target.TargetID(s)     => pID(s)
            case Target.TargetMember(e) => Pretty.pPrintPrec(d, p, e)
            case Target.TargetIndex(e)  => Pretty.pPrintPrec(d, p, e)
        }
    }


}

