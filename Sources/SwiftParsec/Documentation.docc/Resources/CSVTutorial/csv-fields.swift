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

    //...
}
