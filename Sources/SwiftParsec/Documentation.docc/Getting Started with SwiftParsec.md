# Getting Started with SwiftParsec

## Introduction
SwiftParsec is a pure Swift implementation of the Parsec library. Parsec is a powerful parsing library that uses combinatory parsing to achieve excellent performance and flexibility. With SwiftParsec, you can build complex parsers by combining simple ones.

## Installation

Before we start, make sure you have SwiftParsec installed in your project. If you're using Swift Package Manager, you can add SwiftParsec to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/davedufresne/SwiftParsec.git", from: "1.0.0")
]
```

Then, add SwiftParsec to your target's dependencies:

```swift
.target(name: "YourTarget", dependencies: ["SwiftParsec"]),
```

Then, import SwiftParsec in your Swift project:

```swift
import SwiftParsec
```

## Creating a Simple Parser

In SwiftParsec, you create complex parsers by combining simpler ones. Let's start with a basic example: a parser that recognizes a single character.

```swift
let aParser = StringParser.character("a")
```

This parser will match the character "a" in any input string.

## Running a Parser

To run a parser, you use the `run` function, passing in the input string. Here's how you can run our `aParser`:

```swift
let result = try? aParser.run(sourceName: "Basic usage", input: "abc")
```

If the parser successfully matches the input, `run` returns the matched value. In this case, `result` would be "a".

In this case even if we change the input to be "aaaabc" the `result` would still be "a".

```swift
let result = try? aParser.run(sourceName: "Basic usage", input: "aaaabc")
```

Even though there are multiple "a" characters at the start of the input string. This is because the parser only matches the first "a" character it encounters, and then it stops parsing.

This limitation can be overcome by using the `many` or `many1` combinator, which allows the parser to match multiple occurrences of a character. The many combinator matches zero or more occurrences of the parser, while `many1` matches one or more occurrences.

Here's how you can create a parser that matches multiple "a" characters:

```swift
let aParser = StringParser.character("a").many1.stringValue
```

This parser will match one or more "a" characters in any input string and convert them into a string.

Now running:

```swift
let result = try? aParser.run(sourceName: "Basic usage", input: "aaaabc")
```

Now the result of parsing the previous input is "aaaa".

## Combining Parsers

The real power of SwiftParsec comes from combining parsers. This is done using combinators, which are functions that take one or more parsers and return a new parser. For example, you can create a parser that recognizes the string "aaaabc" like this:

```swift
let abcParser = StringParser.string("aaaabc")
```

Or, you can combine our `aParser` with another parser that recognizes "bc" using the >>- operator and the lift2 function:

```swift
let aParser = StringParser.character("a").many1.stringValue
let bcParser = StringParser.string("bc")

// Using the `>>-` operator
let abcParser1 = aParser >>- { a in
    bcParser >>- { bc in
        GenericParser(result: a + bc)
    }
}

// Using the `lift2` function
let abcParser2 = GenericParser.lift2(+, parser1: aParser, parser2: bcParser)

```

In these examples, abcParser1 and abcParser2 will first match one or more "a" characters, and then they will match the string "bc". The results of both parsers are combined into a single string. These are great ways to combine the results of multiple parsers into a single result. By using functions like >>- and lift2, you can create complex parsers that can parse a wide variety of input.

Now, let's look at an example of a parser that parses a list of comma-separated numbers:

```swift
import SwiftParsec

let number = StringParser.digit.many1.stringValue.map { Int($0)! }
let comma = StringParser.character(",")
let numbers = number.separatedBy(comma)

if let result = try? numbers.run(sourceName: "number parser", input: "1,2,3,4,5") {
    print(result)
}
```

n this example, we first define a number parser that matches one or more digits and converts them into an integer. We then define a comma parser that matches the comma character. Finally, we define a numbers parser that matches a list of numbers separated by commas.

The separatedBy combinator is used to match a list of items separated by a separator. In this case, it matches a list of numbers separated by commas.

This example demonstrates how you can combine simple parsers to create more complex parsers. By using combinators, you can create parsers that can parse a wide variety of input.

Handling Errors
SwiftParsec provides a way to handle errors that may occur during parsing. When a parser fails to match the input, it throws a ``ParseError`` that you can catch and handle.

Here's an example of how to handle errors in SwiftParsec:

```swift
let aParser = StringParser.character("a")

do {
    let result = try aParser.run(sourceName: "error handling", input: "b")
    print(result)
} catch let error as ParseError {
    print("Parsing failed with error: \(error)")
} catch {
    print("An unknown error occurred: \(error)")
}
```

In this example, aParser expects to match the character "a". However, the input string is "b", so the parser fails to match the input and throws a ParseError.

The do-catch statement is used to handle the error. If a ParseError is thrown, it's caught and handled by printing an error message. If an unknown error is thrown, it's also caught and handled by printing a different error message.

The ParseError object contains information about the error, such as the location of the error in the input and a message describing the error. You can use this information to diagnose and fix the error.

When you run this code, you'll see the following output:

```
Parsing failed with error: "error handling" (line 1, column 1):
unexpected "b"
expecting "a"
```

This output tells you that the parser failed at line 1, column 1 of the input, where it encountered an unexpected "b" and was expecting an "a".

Remember, error handling is an important part of writing a parser. Always make sure to handle errors appropriately in your parsers.
