// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "sURL",
    dependencies: [],
    targets: [
        .target(name: "sURL", dependencies: ["sURLCore"]),
        .target(name:"sURLCore"),
        .testTarget(name: "sURLTests", dependencies: ["sURL"]),
    ]
)
