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

            let nameValue: GenericParser<String, (), (String, JSONValue)> =
            stringLiteral >>- { name in
                symbol(":") *> jvalue.map { value in (name, value) }
            }

            let dictionary: GenericParser<String, (), [String: JSONValue]> =
            (symbol(",") *> nameValue).manyAccumulator { (assoc, dict) in
                var dict = dict
                let (name, value) = assoc
                dict[name] = value
                return dict
            }

            let jobjectDict: GenericParser<String, (), [String: JSONValue]> =
            nameValue >>- { assoc in
                dictionary >>- { (dict) in
                    var dict = dict
                    let (name, value) = assoc
                    dict[name] = value
                    return GenericParser(result: dict)
                }
            }

            let jobjectValues = jobjectDict <|> GenericParser(result: [:])
            jobject = JSONValue.JObject <^> lexer.braces(jobjectValues)

            return jstring <|> jnumber <|> jbool <|> jnull <|> jarray <|> jobject
        }

        // Rest of the code...

    }()

    // Rest of the code...

}
