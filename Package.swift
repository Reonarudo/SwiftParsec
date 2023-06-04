// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
//  Package.swift
//  SwiftParsec
//
//  Created by David Dufresne on 2016-05-10.
//  Copyright © 2016 David Dufresne. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "SwiftParsec",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftParsec",
            targets: ["SwiftParsec"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftParsec"),
        .testTarget(
            name: "SwiftParsecTests",
            dependencies: ["SwiftParsec"],
            resources: [
                .copy("Resources")
            ]),
    ]
)

