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


mod BasicBim.Pset.Address {

    use BasicBim.Base.Syntax.{Expr, stringLiteralNoneWhenEmpty, otherLiteralOrNone}
    use BasicBim.Pset.Base
    use BasicBim.Pset.Base.Bool3 



    pub type alias Pset_Address = {
        purpose = String,
        description = String,
        user_defined_purpose = String,
        internal_location = String,
        address_lines = String,
        postal_box = String,
        town = String,
        address_region = String,
        postal_code = String,
        country = String,
        telephone_numbers = String,
        facsimile_numbers = String,
        pager_number = String,
        electronic_mail_addresses = String,
        www_home_page_url = String,
        messaging_ids = String
    }
    
    pub type alias Pset_AddressSetter = Pset_Address -> Pset_Address

    def blankPset_Address(): Pset_Address = { 
        purpose = "NOTKNOWN",
        description = "",
        user_defined_purpose = "",
        internal_location = "",
        address_lines = "",
        postal_box = "",
        town = "",
        address_region = "",
        postal_code = "",
        country = "",
        telephone_numbers = "",
        facsimile_numbers = "",
        pager_number = "",
        electronic_mail_addresses = "",
        www_home_page_url = "",
        messaging_ids = ""
    }    

    pub def pset_Address(f: Pset_AddressSetter): Pset_Address = f(blankPset_Address())

    pub def toExpr(x: Pset_Address): Expr = 
        Expr.Dict(List#{
            ("Purpose", stringLiteralNoneWhenEmpty(x#purpose)),
            ("Description", stringLiteralNoneWhenEmpty(x#description)),
            ("UserDefinedPurpose", stringLiteralNoneWhenEmpty(x#user_defined_purpose)),
            ("InternalLocation", stringLiteralNoneWhenEmpty(x#internal_location)),
            ("AddressLines", stringLiteralNoneWhenEmpty(x#address_lines)),
            ("PostalBox", stringLiteralNoneWhenEmpty(x#postal_box)),
            ("Town", stringLiteralNoneWhenEmpty(x#town)),
            ("Region", stringLiteralNoneWhenEmpty(x#address_region)),
            ("PostalCode", stringLiteralNoneWhenEmpty(x#postal_code)),
            ("Country", stringLiteralNoneWhenEmpty(x#country)),
            ("TelephoneNumbers", stringLiteralNoneWhenEmpty(x#telephone_numbers)),
            ("FacsimileNumbers", stringLiteralNoneWhenEmpty(x#facsimile_numbers)),
            ("PagerNumber", stringLiteralNoneWhenEmpty(x#pager_number)),
            ("ElectronicMailAddresses", stringLiteralNoneWhenEmpty(x#electronic_mail_addresses)),
            ("WWWHomePageURL", stringLiteralNoneWhenEmpty(x#www_home_page_url)),
            ("MessagingIDs", stringLiteralNoneWhenEmpty(x#messaging_ids))
        })

}
