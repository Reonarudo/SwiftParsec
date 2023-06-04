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

        // Rest of the code...

    }()

    // Rest of the code...

}
