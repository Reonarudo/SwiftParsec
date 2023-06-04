import SwiftParsec

func csvParser() -> GenericParser<String, (), [[String]]> {
    // Parser code goes here
    let noneOf = StringParser.noneOf

    let quotedChars = noneOf("\"") <|>
    StringParser.string("\"\"").attempt *>
    GenericParser(result: "\"")

    //...
}
