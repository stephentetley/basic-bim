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


mod BasicBim.Colour.NamedColours {

    use BasicBim.Base.Syntax.{Expr, stringLiteral, otherLiteral}

    pub type alias NamedColour = {
        name = String,
        red = Float64,
        green = Float64,
        blue = Float64
    }

    pub def toExpr(x: NamedColour): Expr = 
        Expr.Dict(List#{
            ("Name", stringLiteral(x#name)),
            ("Red", otherLiteral(x#red)),
            ("Green", otherLiteral(x#green)),
            ("Blue", otherLiteral(x#blue))
        })

    pub def aliceblue(): NamedColour = {name = "aliceblue", red = 0.94f64, green = 0.97f64, blue = 1.00f64}
    pub def antiquewhite(): NamedColour = {name = "antiquewhite", red = 0.98f64, green = 0.92f64, blue = 0.84f64}
    pub def aqua(): NamedColour = {name = "aqua", red = 0.00f64, green = 1.00f64, blue = 1.00f64}
    pub def aquamarine(): NamedColour = {name = "aquamarine", red = 0.50f64, green = 1.00f64, blue = 0.83f64}
    pub def azure(): NamedColour = {name = "azure", red = 0.94f64, green = 1.00f64, blue = 1.00f64}
    pub def beige(): NamedColour = {name = "beige", red = 0.96f64, green = 0.96f64, blue = 0.86f64}
    pub def bisque(): NamedColour = {name = "bisque", red = 1.00f64, green = 0.89f64, blue = 0.77f64}
    pub def black(): NamedColour = {name = "black", red = 0.00f64, green = 0.00f64, blue = 0.00f64}
    pub def blanchedalmond(): NamedColour = {name = "blanchedalmond", red = 1.00f64, green = 0.92f64, blue = 0.80f64}
    pub def blue(): NamedColour = {name = "blue", red = 0.00f64, green = 0.00f64, blue = 1.00f64}
    pub def blueviolet(): NamedColour = {name = "blueviolet", red = 0.54f64, green = 0.17f64, blue = 0.89f64}
    pub def brown(): NamedColour = {name = "brown", red = 0.65f64, green = 0.16f64, blue = 0.16f64}
    pub def burlywood(): NamedColour = {name = "burlywood", red = 0.87f64, green = 0.72f64, blue = 0.53f64}
    pub def cadetblue(): NamedColour = {name = "cadetblue", red = 0.37f64, green = 0.62f64, blue = 0.63f64}
    pub def chartreuse(): NamedColour = {name = "chartreuse", red = 0.50f64, green = 1.00f64, blue = 0.00f64}
    pub def chocolate(): NamedColour = {name = "chocolate", red = 0.82f64, green = 0.41f64, blue = 0.12f64}
    pub def coral(): NamedColour = {name = "coral", red = 1.00f64, green = 0.50f64, blue = 0.31f64}
    pub def cornflowerblue(): NamedColour = {name = "cornflowerblue", red = 0.39f64, green = 0.58f64, blue = 0.93f64}
    pub def cornsilk(): NamedColour = {name = "cornsilk", red = 1.00f64, green = 0.97f64, blue = 0.86f64}
    pub def crimson(): NamedColour = {name = "crimson", red = 0.86f64, green = 0.08f64, blue = 0.24f64}
    pub def cyan(): NamedColour = {name = "cyan", red = 0.00f64, green = 1.00f64, blue = 1.00f64}
    pub def darkblue(): NamedColour = {name = "darkblue", red = 0.00f64, green = 0.00f64, blue = 0.55f64}
    pub def darkcyan(): NamedColour = {name = "darkcyan", red = 0.00f64, green = 0.55f64, blue = 0.55f64}
    pub def darkgoldenrod(): NamedColour = {name = "darkgoldenrod", red = 0.72f64, green = 0.53f64, blue = 0.04f64}
    pub def darkgray(): NamedColour = {name = "darkgray", red = 0.66f64, green = 0.66f64, blue = 0.66f64}
    pub def darkgreen(): NamedColour = {name = "darkgreen", red = 0.00f64, green = 0.39f64, blue = 0.00f64}
    pub def darkgrey(): NamedColour = {name = "darkgrey", red = 0.66f64, green = 0.66f64, blue = 0.66f64}
    pub def darkkhaki(): NamedColour = {name = "darkkhaki", red = 0.74f64, green = 0.72f64, blue = 0.42f64}
    pub def darkmagenta(): NamedColour = {name = "darkmagenta", red = 0.55f64, green = 0.00f64, blue = 0.55f64}
    pub def darkolivegreen(): NamedColour = {name = "darkolivegreen", red = 0.33f64, green = 0.42f64, blue = 0.18f64}
    pub def darkorange(): NamedColour = {name = "darkorange", red = 1.00f64, green = 0.55f64, blue = 0.00f64}
    pub def darkorchid(): NamedColour = {name = "darkorchid", red = 0.60f64, green = 0.20f64, blue = 0.80f64}
    pub def darkred(): NamedColour = {name = "darkred", red = 0.55f64, green = 0.00f64, blue = 0.00f64}
    pub def darksalmon(): NamedColour = {name = "darksalmon", red = 0.91f64, green = 0.59f64, blue = 0.48f64}
    pub def darkseagreen(): NamedColour = {name = "darkseagreen", red = 0.56f64, green = 0.74f64, blue = 0.56f64}
    pub def darkslateblue(): NamedColour = {name = "darkslateblue", red = 0.28f64, green = 0.24f64, blue = 0.55f64}
    pub def darkslategray(): NamedColour = {name = "darkslategray", red = 0.18f64, green = 0.31f64, blue = 0.31f64}
    pub def darkslategrey(): NamedColour = {name = "darkslategrey", red = 0.18f64, green = 0.31f64, blue = 0.31f64}
    pub def darkturquoise(): NamedColour = {name = "darkturquoise", red = 0.00f64, green = 0.81f64, blue = 0.82f64}
    pub def darkviolet(): NamedColour = {name = "darkviolet", red = 0.58f64, green = 0.00f64, blue = 0.83f64}
    pub def deeppink(): NamedColour = {name = "deeppink", red = 1.00f64, green = 0.08f64, blue = 0.58f64}
    pub def deepskyblue(): NamedColour = {name = "deepskyblue", red = 0.00f64, green = 0.75f64, blue = 1.00f64}
    pub def dimgray(): NamedColour = {name = "dimgray", red = 0.41f64, green = 0.41f64, blue = 0.41f64}
    pub def dimgrey(): NamedColour = {name = "dimgrey", red = 0.41f64, green = 0.41f64, blue = 0.41f64}
    pub def dodgerblue(): NamedColour = {name = "dodgerblue", red = 0.12f64, green = 0.56f64, blue = 1.00f64}
    pub def firebrick(): NamedColour = {name = "firebrick", red = 0.70f64, green = 0.13f64, blue = 0.13f64}
    pub def floralwhite(): NamedColour = {name = "floralwhite", red = 1.00f64, green = 0.98f64, blue = 0.94f64}
    pub def forestgreen(): NamedColour = {name = "forestgreen", red = 0.13f64, green = 0.55f64, blue = 0.13f64}
    pub def fuchsia(): NamedColour = {name = "fuchsia", red = 1.00f64, green = 0.00f64, blue = 1.00f64}
    pub def gainsboro(): NamedColour = {name = "gainsboro", red = 0.86f64, green = 0.86f64, blue = 0.86f64}
    pub def ghostwhite(): NamedColour = {name = "ghostwhite", red = 0.97f64, green = 0.97f64, blue = 1.00f64}
    pub def gold(): NamedColour = {name = "gold", red = 1.00f64, green = 0.84f64, blue = 0.00f64}
    pub def goldenrod(): NamedColour = {name = "goldenrod", red = 0.85f64, green = 0.65f64, blue = 0.13f64}
    pub def gray(): NamedColour = {name = "gray", red = 0.50f64, green = 0.50f64, blue = 0.50f64}
    pub def grey(): NamedColour = {name = "grey", red = 0.50f64, green = 0.50f64, blue = 0.50f64}
    pub def green(): NamedColour = {name = "green", red = 0.00f64, green = 0.50f64, blue = 0.00f64}
    pub def greenyellow(): NamedColour = {name = "greenyellow", red = 0.68f64, green = 1.00f64, blue = 0.18f64}
    pub def honeydew(): NamedColour = {name = "honeydew", red = 0.94f64, green = 1.00f64, blue = 0.94f64}
    pub def hotpink(): NamedColour = {name = "hotpink", red = 1.00f64, green = 0.41f64, blue = 0.71f64}
    pub def indianred(): NamedColour = {name = "indianred", red = 0.80f64, green = 0.36f64, blue = 0.36f64}
    pub def indigo(): NamedColour = {name = "indigo", red = 0.29f64, green = 0.00f64, blue = 0.51f64}
    pub def ivory(): NamedColour = {name = "ivory", red = 1.00f64, green = 1.00f64, blue = 0.94f64}
    pub def khaki(): NamedColour = {name = "khaki", red = 0.94f64, green = 0.90f64, blue = 0.55f64}
    pub def lavender(): NamedColour = {name = "lavender", red = 0.90f64, green = 0.90f64, blue = 0.98f64}
    pub def lavenderblush(): NamedColour = {name = "lavenderblush", red = 1.00f64, green = 0.94f64, blue = 0.96f64}
    pub def lawngreen(): NamedColour = {name = "lawngreen", red = 0.49f64, green = 0.99f64, blue = 0.00f64}
    pub def lemonchiffon(): NamedColour = {name = "lemonchiffon", red = 1.00f64, green = 0.98f64, blue = 0.80f64}
    pub def lightblue(): NamedColour = {name = "lightblue", red = 0.68f64, green = 0.85f64, blue = 0.90f64}
    pub def lightcoral(): NamedColour = {name = "lightcoral", red = 0.94f64, green = 0.50f64, blue = 0.50f64}
    pub def lightcyan(): NamedColour = {name = "lightcyan", red = 0.88f64, green = 1.00f64, blue = 1.00f64}
    pub def lightgoldenrodyellow(): NamedColour = {name = "lightgoldenrodyellow", red = 0.98f64, green = 0.98f64, blue = 0.82f64}
    pub def lightgray(): NamedColour = {name = "lightgray", red = 0.83f64, green = 0.83f64, blue = 0.83f64}
    pub def lightgreen(): NamedColour = {name = "lightgreen", red = 0.56f64, green = 0.93f64, blue = 0.56f64}
    pub def lightgrey(): NamedColour = {name = "lightgrey", red = 0.83f64, green = 0.83f64, blue = 0.83f64}
    pub def lightpink(): NamedColour = {name = "lightpink", red = 1.00f64, green = 0.71f64, blue = 0.76f64}
    pub def lightsalmon(): NamedColour = {name = "lightsalmon", red = 1.00f64, green = 0.63f64, blue = 0.48f64}
    pub def lightseagreen(): NamedColour = {name = "lightseagreen", red = 0.13f64, green = 0.70f64, blue = 0.67f64}
    pub def lightskyblue(): NamedColour = {name = "lightskyblue", red = 0.53f64, green = 0.81f64, blue = 0.98f64}
    pub def lightslategray(): NamedColour = {name = "lightslategray", red = 0.47f64, green = 0.53f64, blue = 0.60f64}
    pub def lightslategrey(): NamedColour = {name = "lightslategrey", red = 0.47f64, green = 0.53f64, blue = 0.60f64}
    pub def lightsteelblue(): NamedColour = {name = "lightsteelblue", red = 0.69f64, green = 0.77f64, blue = 0.87f64}
    pub def lightyellow(): NamedColour = {name = "lightyellow", red = 1.00f64, green = 1.00f64, blue = 0.88f64}
    pub def lime(): NamedColour = {name = "lime", red = 0.00f64, green = 1.00f64, blue = 0.00f64}
    pub def limegreen(): NamedColour = {name = "limegreen", red = 0.20f64, green = 0.80f64, blue = 0.20f64}
    pub def linen(): NamedColour = {name = "linen", red = 0.98f64, green = 0.94f64, blue = 0.90f64}
    pub def magenta(): NamedColour = {name = "magenta", red = 1.00f64, green = 0.00f64, blue = 1.00f64}
    pub def maroon(): NamedColour = {name = "maroon", red = 0.50f64, green = 0.00f64, blue = 0.00f64}
    pub def mediumaquamarine(): NamedColour = {name = "mediumaquamarine", red = 0.40f64, green = 0.80f64, blue = 0.67f64}
    pub def mediumblue(): NamedColour = {name = "mediumblue", red = 0.00f64, green = 0.00f64, blue = 0.80f64}
    pub def mediumorchid(): NamedColour = {name = "mediumorchid", red = 0.73f64, green = 0.33f64, blue = 0.83f64}
    pub def mediumpurple(): NamedColour = {name = "mediumpurple", red = 0.58f64, green = 0.44f64, blue = 0.86f64}
    pub def mediumseagreen(): NamedColour = {name = "mediumseagreen", red = 0.24f64, green = 0.70f64, blue = 0.44f64}
    pub def mediumslateblue(): NamedColour = {name = "mediumslateblue", red = 0.48f64, green = 0.41f64, blue = 0.93f64}
    pub def mediumspringgreen(): NamedColour = {name = "mediumspringgreen", red = 0.00f64, green = 0.98f64, blue = 0.60f64}
    pub def mediumturquoise(): NamedColour = {name = "mediumturquoise", red = 0.28f64, green = 0.82f64, blue = 0.80f64}
    pub def mediumvioletred(): NamedColour = {name = "mediumvioletred", red = 0.78f64, green = 0.08f64, blue = 0.52f64}
    pub def midnightblue(): NamedColour = {name = "midnightblue", red = 0.10f64, green = 0.10f64, blue = 0.44f64}
    pub def mintcream(): NamedColour = {name = "mintcream", red = 0.96f64, green = 1.00f64, blue = 0.98f64}
    pub def mistyrose(): NamedColour = {name = "mistyrose", red = 1.00f64, green = 0.89f64, blue = 0.88f64}
    pub def moccasin(): NamedColour = {name = "moccasin", red = 1.00f64, green = 0.89f64, blue = 0.71f64}
    pub def navajowhite(): NamedColour = {name = "navajowhite", red = 1.00f64, green = 0.87f64, blue = 0.68f64}
    pub def navy(): NamedColour = {name = "navy", red = 0.00f64, green = 0.00f64, blue = 0.50f64}
    pub def oldlace(): NamedColour = {name = "oldlace", red = 0.99f64, green = 0.96f64, blue = 0.90f64}
    pub def olive(): NamedColour = {name = "olive", red = 0.50f64, green = 0.50f64, blue = 0.00f64}
    pub def olivedrab(): NamedColour = {name = "olivedrab", red = 0.42f64, green = 0.56f64, blue = 0.14f64}
    pub def orange(): NamedColour = {name = "orange", red = 1.00f64, green = 0.65f64, blue = 0.00f64}
    pub def orangered(): NamedColour = {name = "orangered", red = 1.00f64, green = 0.27f64, blue = 0.00f64}
    pub def orchid(): NamedColour = {name = "orchid", red = 0.85f64, green = 0.44f64, blue = 0.84f64}
    pub def palegoldenrod(): NamedColour = {name = "palegoldenrod", red = 0.93f64, green = 0.91f64, blue = 0.67f64}
    pub def palegreen(): NamedColour = {name = "palegreen", red = 0.60f64, green = 0.98f64, blue = 0.60f64}
    pub def paleturquoise(): NamedColour = {name = "paleturquoise", red = 0.69f64, green = 0.93f64, blue = 0.93f64}
    pub def palevioletred(): NamedColour = {name = "palevioletred", red = 0.86f64, green = 0.44f64, blue = 0.58f64}
    pub def papayawhip(): NamedColour = {name = "papayawhip", red = 1.00f64, green = 0.94f64, blue = 0.84f64}
    pub def peachpuff(): NamedColour = {name = "peachpuff", red = 1.00f64, green = 0.85f64, blue = 0.73f64}
    pub def peru(): NamedColour = {name = "peru", red = 0.80f64, green = 0.52f64, blue = 0.25f64}
    pub def pink(): NamedColour = {name = "pink", red = 1.00f64, green = 0.75f64, blue = 0.80f64}
    pub def plum(): NamedColour = {name = "plum", red = 0.87f64, green = 0.63f64, blue = 0.87f64}
    pub def powderblue(): NamedColour = {name = "powderblue", red = 0.69f64, green = 0.88f64, blue = 0.90f64}
    pub def purple(): NamedColour = {name = "purple", red = 0.50f64, green = 0.00f64, blue = 0.50f64}
    pub def red(): NamedColour = {name = "red", red = 1.00f64, green = 0.00f64, blue = 0.00f64}
    pub def rosybrown(): NamedColour = {name = "rosybrown", red = 0.74f64, green = 0.56f64, blue = 0.56f64}
    pub def royalblue(): NamedColour = {name = "royalblue", red = 0.25f64, green = 0.41f64, blue = 0.88f64}
    pub def saddlebrown(): NamedColour = {name = "saddlebrown", red = 0.55f64, green = 0.27f64, blue = 0.07f64}
    pub def salmon(): NamedColour = {name = "salmon", red = 0.98f64, green = 0.50f64, blue = 0.45f64}
    pub def sandybrown(): NamedColour = {name = "sandybrown", red = 0.96f64, green = 0.64f64, blue = 0.38f64}
    pub def seagreen(): NamedColour = {name = "seagreen", red = 0.18f64, green = 0.55f64, blue = 0.34f64}
    pub def seashell(): NamedColour = {name = "seashell", red = 1.00f64, green = 0.96f64, blue = 0.93f64}
    pub def sienna(): NamedColour = {name = "sienna", red = 0.63f64, green = 0.32f64, blue = 0.18f64}
    pub def silver(): NamedColour = {name = "silver", red = 0.75f64, green = 0.75f64, blue = 0.75f64}
    pub def skyblue(): NamedColour = {name = "skyblue", red = 0.53f64, green = 0.81f64, blue = 0.92f64}
    pub def slateblue(): NamedColour = {name = "slateblue", red = 0.42f64, green = 0.35f64, blue = 0.80f64}
    pub def slategray(): NamedColour = {name = "slategray", red = 0.44f64, green = 0.50f64, blue = 0.56f64}
    pub def slategrey(): NamedColour = {name = "slategrey", red = 0.44f64, green = 0.50f64, blue = 0.56f64}
    pub def snow(): NamedColour = {name = "snow", red = 1.00f64, green = 0.98f64, blue = 0.98f64}
    pub def springgreen(): NamedColour = {name = "springgreen", red = 0.00f64, green = 1.00f64, blue = 0.50f64}
    pub def steelblue(): NamedColour = {name = "steelblue", red = 0.27f64, green = 0.51f64, blue = 0.71f64}
    pub def tan(): NamedColour = {name = "tan", red = 0.82f64, green = 0.71f64, blue = 0.55f64}
    pub def teal(): NamedColour = {name = "teal", red = 0.00f64, green = 0.50f64, blue = 0.50f64}
    pub def thistle(): NamedColour = {name = "thistle", red = 0.85f64, green = 0.75f64, blue = 0.85f64}
    pub def tomato(): NamedColour = {name = "tomato", red = 1.00f64, green = 0.39f64, blue = 0.28f64}
    pub def turquoise(): NamedColour = {name = "turquoise", red = 0.25f64, green = 0.88f64, blue = 0.82f64}
    pub def violet(): NamedColour = {name = "violet", red = 0.93f64, green = 0.51f64, blue = 0.93f64}
    pub def wheat(): NamedColour = {name = "wheat", red = 0.96f64, green = 0.87f64, blue = 0.70f64}
    pub def white(): NamedColour = {name = "white", red = 1.00f64, green = 1.00f64, blue = 1.00f64}
    pub def whitesmoke(): NamedColour = {name = "whitesmoke", red = 0.96f64, green = 0.96f64, blue = 0.96f64}
    pub def yellow(): NamedColour = {name = "yellow", red = 1.00f64, green = 1.00f64, blue = 0.00f64}
    pub def yellowgreen(): NamedColour = {name = "yellowgreen", red = 0.60f64, green = 0.80f64, blue = 0.20f64}



}
