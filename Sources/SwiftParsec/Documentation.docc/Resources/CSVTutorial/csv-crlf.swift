import SwiftParsec

func csvParser() -> GenericParser<String, (), [[String]]> {
    // Parser code goes here
    let noneOf = StringParser.noneOf

    let quotedChars = noneOf("\"") <|>
    StringParser.string("\"\"").attempt *>
    GenericParser(result: "\"")

    let character = StringParser.character

    let quote = character("\"")
    let quotedField = quote *> quotedChars.many.stringValue <*
    (quote <?> "quote at end of field")

    let field = quotedField <|> noneOf("\r\n,\n\r").many.stringValue

    let record = field.separatedBy(character(","))

    let endOfLine = StringParser.crlf.attempt <|>
    (character("\n") *> character("\r")).attempt <|>
    character("\n") <|>
    character("\r") <?> "end of line"

    //...
}
