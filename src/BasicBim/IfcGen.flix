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


    trait PyVariable[t] {
        pub def getName(x: t): String
    }

}



mod BasicBim.IfcGen {

    use BasicBim.Base.Syntax.{Code, Stmt}
    use BasicBim.PyVariable

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

    pub def freshvar(): IfcGen[cx, String] \ {} =
        IfcGen((code, i) -> (code, i+1, "v" + ToString.toString(i)))


    pub def pyImport(name: String): IfcGen[cx, Unit] \ {} =
        tell(BasicBim.Base.Syntax.Stmt.Import(name))

    // pub def pyAssign(v: String, body: String): IfcGen[cx, Unit] \ {} =
    //     tell("${v} = ${body}")


    // pub def pyInvoke(body: String): IfcGen[cx, Unit] \ {} =
    //     tell(body)

    // pub def pyComment(body: String): IfcGen[cx, Unit] \ {} =
    //     let lines = String.lines(body);
    //     Foldable.forEachM(s -> tell("# ${s}"), lines)
    
    // pub def blankLine(): IfcGen[cx, Unit] \ {} = tell("")

    pub enum IfcSIUnit(String)

    instance PyVariable[IfcSIUnit] {
        pub def getName(v: IfcSIUnit): String = 
            let IfcSIUnit.IfcSIUnit(v1) = v;
            v1
    }

    // pub def pyAssign2(v: a, body: String): IfcGen[cx, a] \ {} with PyVariable[a] =
    //     let v1 = PyVariable.getName(v);
    //     forM (_ <- tell("${v1} = ${body}")) yield v



}
