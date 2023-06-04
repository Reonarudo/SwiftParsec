# Advanced Topics with SwiftParsec

Welcome to the advanced topics guide for SwiftParsec! In this guide, we'll delve deeper into some of the more complex aspects of using SwiftParsec, including monadic operations and recursive parsers.

Absolutely, here's how the updated section would look:

## Monadic Operations

Monadic operations, such as ``GenericParser/flatMap(_:)``, allow you to chain parsers together in a way that the result of one parser can influence the next one. Here's an example:

```swift
let parser = StringParser.digit.stringValue.flatMap { digit in
StringParser.character("a").count(Int(digit)!).stringValue
}
```

In this example, we first parse a digit. We then use ``GenericParser/flatMap(_:)`` to create a new parser that matches as many 'a' characters as the digit we parsed. So if the input is "3aaa", the parser will succeed, but if the input is "3aa", it will fail because there are not enough 'a' characters.

SwiftParsec also provides an alternative notation for ``GenericParser/flatMap(_:)`` using the ``SwiftParsec/__-(_:_:)`` operator:

```swift
let parser = StringParser.digit.stringValue >>- { digit in
StringParser.character("a").count(Int(digit)!).stringValue
}
```

This does exactly the same thing as the previous example, but some people find this notation more readable, especially when chaining multiple parsers together.

## Recursive Parsers

Recursive parsers are parsers that refer to themselves. They are useful for parsing nested or recursive structures, like parentheses or JSON.

Here's an example of a ``GenericParser/recursive(_:)`` parser that parses nested parentheses:

```swift
let parenParser: GenericParser<String, (), String> = GenericParser.recursive { parenParser in
    let openParen = StringParser.character("(")
    let closeParen = StringParser.character(")")
    let nestedParens = openParen >>- { _ in
        parenParser >>- { inner in
            closeParen >>- { _ in
                GenericParser(result: inner)
            }
        }
    }
    return nestedParens <|> StringParser.character("a").stringValue
}
```

In this example, `parenParser` is a parser that matches either a single 'a' character or a pair of parentheses containing another `parenParser`. This allows it to match arbitrarily nested parentheses.

Remember, recursive parsers can be tricky to get right, and they can lead to infinite loops if not handled carefully. Make sure to have a base case that doesn't refer to the parser itself!

We hope this guide has given you a deeper understanding of some of the more advanced features of SwiftParsec.
