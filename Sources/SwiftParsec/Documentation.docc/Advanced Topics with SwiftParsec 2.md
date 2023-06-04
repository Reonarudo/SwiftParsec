# Advanced Topics with SwiftParsec (part 2)
In this second part of our advanced topics guide, we will delve deeper into the capabilities of SwiftParsec. We'll cover backtracking and lookahead, two powerful techniques that can greatly enhance the flexibility and power of your parsers.

## Backtracking

Backtracking is a fundamental concept in parsing. It refers to the ability of the parser to "go back" and try a different parsing strategy when it encounters a parsing error. This is crucial in situations where the parser needs to choose between multiple valid parsing paths.

In SwiftParsec, backtracking is handled by the attempt function. This function allows a parser to be tried without consuming any input. If the parser fails, it will not consume any input, allowing the next parser to start from the same position.

Let's illustrate this with an example. Suppose we have a language that has two types of statements: if statements and print statements. An if statement starts with the keyword if, followed by a condition, and then a block of code. A print statement starts with the keyword print, followed by a string to print.

In SwiftParsec, we can define parsers for these statements like this:

@Comment {
    ```swift
    // consumes `if true { code }`
    let conditionParser = StringParser.spaces *> (StringParser.string("true").map { _ in true } <|> StringParser.string("false").map { _ in false }) <* StringParser.spaces
    
    let blockParser = StringParser.character("{") *> StringParser.noneOf("}").many <* StringParser.character("}")
    
    // consumes `print "Hello, world!"`
    let printStatement = StringParser.spaces *> StringParser.string("print") *> stringLiteralParser <* StringParser.spaces
    ```
}

```swift
// consumes "if true { code }"
let ifStatement = string("if") *> conditionParser *> blockParser
let printStatement = string("print") *> stringLiteralParser
```

Now, suppose we want to parse a statement that could be either an if statement or a print statement. We could try to parse it with the ifStatement parser, and if that fails, we backtrack and try the printStatement parser. This can be done using the ``GenericParser/___(_:_:)-t050`` operator or the quivalent ``GenericParser/alternative(_:)``, which tries the parser on the left, and if it fails without consuming input, it tries the parser on the right:

```swift
let statement = attempt(ifStatement) <|> printStatement
```

In this example, if the input starts with if, the ifStatement parser will be tried. If the input doesn't match the structure of an if statement (for example, if there's no condition after the if), the parser will fail and no input will be consumed. Then, the printStatement parser will be tried from the same position.

This is how backtracking works in SwiftParsec. It allows the parser to recover from errors and try different parsing strategies, making it possible to parse complex languages with ambiguous syntax.

## Lookahead

In some cases, you might want to check if a certain pattern exists in the input, but you don't want to consume it. This is where ``GenericParser/lookAhead`` comes in handy. Lookahead is a technique that allows the parser to peek at the input ahead of the current position without consuming it. This can be useful in situations where the decision to match a certain pattern depends on the surrounding context.

SwiftParsec provides the lookAhead combinator for this purpose. Here's an example:

```swift
import SwiftParsec

// Define the grammar of the language
let letterOrDigit = StringParser.letter <|> StringParser.digit

let identifier = StringParser.letter >>- { first in
    letterOrDigit.many >>- { rest in
        return GenericParser(result: String([first] + rest))
    }
}

let assignment = identifier >>- { id1 in
    StringParser.character("=") >>- { _ in
        identifier >>- { id2 in
            return GenericParser(result: (id1, id2))
        }
    }
}

let lookahead = assignment.lookAhead

// Use the grammar to parse a string
let input = "x=y"
do {
    let result = try lookahead.run(sourceName: "lookahead", input: input)
    print("Parsed successfully: \(result)")
} catch {
    print("Parsing failed with error: \(error)")
}

```

In this example, the ``GenericParser/lookAhead`` parser will check if the input matches the assignment pattern. If it does, the parser will return the matched value, but it will not consume the input. This means that after running the ``GenericParser/lookAhead`` parser, the input will remain unchanged, and the parser's position will be at the start of the input. This is useful when you want to check for a pattern without advancing the parser's position.

It is worth mentioning that SwiftParsec provides another combinator for lookahead operations: ``GenericParser/attempt``. 

The ``GenericParser/attempt`` method allows us to try a parser and revert to the original state if the parser fails. This is useful when we want to try a parser that may fail, but we don't want to consume any input if it does. In other words, attempt allows us to do speculative parsing.

Note that attempt and lookAhead are similar, but they have a key difference: attempt consumes the input if the parser succeeds, while lookAhead never consumes any input, whether the parser succeeds or fails.
