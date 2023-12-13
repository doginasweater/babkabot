// swift-tools-version:5.9
import PackageDescription

let package = Package(
  name: "babkabot",
  platforms: [
    .macOS(.v13)
  ],
  dependencies: [
    // 💧 A server-side Swift web framework.
    .package(url: "https://github.com/vapor/vapor.git", from: "4.89.0"),
    .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
    .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0"),
    .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.0.0"),
    .package(url: "https://github.com/DiscordBM/DiscordBM", from: "1.0.0"),
    .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.9.0"),
    .package(url: "https://github.com/YusukeHosonuma/SwiftPrettyPrint.git", .upToNextMajor(from: "1.2.0")),
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.2.0"),
    .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    .package(url: "https://github.com/DiscordBM/DiscordLogger", from: "1.0.0-beta.1"),
  ],
  targets: [
    .executableTarget(
      name: "App",
      dependencies: [
        .product(name: "Fluent", package: "fluent"),
        .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
        .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
        .product(name: "Vapor", package: "vapor"),
        .product(name: "DiscordBM", package: "DiscordBM"),
        .product(name: "Logging", package: "swift-log"),
        .product(name: "DiscordLogger", package: "DiscordLogger"),
        .product(name: "AsyncHTTPClient", package: "async-http-client"),
        "SwiftPrettyPrint",
      ],
      swiftSettings: [
        // Enable better optimizations when building in Release configuration. Despite the use of
        // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
        // builds. See <https://github.com/swift-server/guides/blob/main/docs/building.md#building-for-production> for details.
        .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release)),
        .enableUpcomingFeature("BareSlashRegexLiterals"),
      ]
    ),
    .testTarget(
      name: "AppTests",
      dependencies: [
        .target(name: "App"),
        .product(name: "XCTVapor", package: "vapor"),
      ]),
  ]
)
