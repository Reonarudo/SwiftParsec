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

        // Rest of the code...

    }()

    // Rest of the code...

}
