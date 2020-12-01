// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "NameThatColor",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "NameThatColor", targets: ["NameThatColor"])
    ],
    targets: [
        .target(name: "NameThatColor", path: "NameThatColor")
    ]
)
