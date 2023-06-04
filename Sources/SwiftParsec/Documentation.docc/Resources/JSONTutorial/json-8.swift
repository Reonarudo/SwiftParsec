import SwiftParsec

public enum JSONValue {

    case JString(String)
    case JNumber(Double)
    case JBool(Bool)
    case JNull
    case JArray([JSONValue])
    case JObject([String: JSONValue])
    case Error

    public static let parser: GenericParser<String, (), JSONValue> = {

        let json = LanguageDefinition<()>.json
        let lexer = GenericTokenParser(languageDefinition: json)

        let symbol = lexer.symbol
        let stringLiteral = lexer.stringLiteral

        let jstring = JSONValue.JString <^> stringLiteral

        let jnumber = JSONValue.JNumber <^>
        (lexer.float.attempt <|> lexer.integerAsFloat)

        let trueValue = symbol("true") *> GenericParser(result: true)
        let falseValue = symbol("false") *> GenericParser(result: false)
        let jbool = JSONValue.JBool <^> (trueValue <|> falseValue)

        let jnull = symbol("null") *> GenericParser(result: JSONValue.JNull)

        var jarray: GenericParser<String, (), JSONValue>!
        var jobject: GenericParser<String, (), JSONValue>!

        GenericParser.recursive { (jvalue: GenericParser<String, (), JSONValue>) in
            let jarrayValues = lexer.commaSeparated(jvalue)
            jarray = JSONValue.JArray <^> lexer.brackets(jarrayValues)
            // Rest of the code...
        }

        // Rest of the code...

    }()

    // Rest of the code...

}
