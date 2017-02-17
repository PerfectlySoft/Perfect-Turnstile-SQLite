// Generated automatically by Perfect Assistant Application
// Date: 2017-02-17 19:43:59 +0000
import PackageDescription
let package = Package(
    name: "PerfectTurnstileSQLite",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/SwiftORM/SQLite-StORM.git", majorVersion: 1),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Mustache.git", majorVersion: 2),
        .Package(url: "https://github.com/iamjono/SwiftString.git", majorVersion: 1),
        .Package(url: "https://github.com/iamjono/SwiftRandom.git", majorVersion: 0),
        .Package(url: "https://github.com/PerfectSideRepos/Turnstile-Perfect.git", majorVersion: 2),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-RequestLogger.git", majorVersion: 1),
    ]
)