# Perfect Turnstile with SQLite

[![Perfect logo](http://www.perfect.org/github/Perfect_GH_header_854.jpg)](http://perfect.org/get-involved.html)

[![Perfect logo](http://www.perfect.org/github/Perfect_GH_button_1_Star.jpg)](https://github.com/PerfectlySoft/Perfect)
[![Perfect logo](http://www.perfect.org/github/Perfect_GH_button_2_Git.jpg)](https://gitter.im/PerfectlySoft/Perfect)
[![Perfect logo](http://www.perfect.org/github/Perfect_GH_button_3_twit.jpg)](https://twitter.com/perfectlysoft)
[![Perfect logo](http://www.perfect.org/github/Perfect_GH_button_4_slack.jpg)](http://perfect.ly)


[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms OS X | Linux](https://img.shields.io/badge/Platforms-OS%20X%20%7C%20Linux%20-lightgray.svg?style=flat)](https://developer.apple.com/swift/)
[![License Apache](https://img.shields.io/badge/License-Apache-lightgrey.svg?style=flat)](http://perfect.org/licensing.html)
[![Twitter](https://img.shields.io/badge/Twitter-@PerfectlySoft-blue.svg?style=flat)](http://twitter.com/PerfectlySoft)
[![Join the chat at https://gitter.im/PerfectlySoft/Perfect](https://img.shields.io/badge/Gitter-Join%20Chat-brightgreen.svg)](https://gitter.im/PerfectlySoft/Perfect?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Slack Status](http://perfect.ly/badge.svg)](http://perfect.ly) [![GitHub version](https://badge.fury.io/gh/PerfectlySoft%2FPerfect-CURL.svg)](https://badge.fury.io/gh/PerfectlySoft%2FPerfect-CURL)

This project integrates Stormpath's Turnstile authentication system into a single package with Perfect, and a SQLite ORM.

## Installation

In your Package.swift file, include the following line inside the dependancy array:

``` swift
.Package(
	url: "https://github.com/PerfectlySoft/Perfect-Turnstile-SQLite.git",
	majorVersion: 0, minor: 0
	)
```

## Included JSON Routes

The framework includes certain basic routes:

```
POST /api/v1/login (with username & password form elements)
POST /api/v1/register (with username & password form elements)
GET /api/v1/logout
```

## Included Routes for Browser

The following routes are available for browser testing:

```
http://localhost:8181
http://localhost:8181/login
http://localhost:8181/register
```

These routes are using Mustache files in the webroot directory.

## Creating an HTTP Server with Authentication

``` swift 
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

import SQLiteStORM
import PerfectTurnstileSQLite

// Used later in script for the Realm and how the user authenticates.
let pturnstile = TurnstilePerfectRealm()

// Set the connection vatiable
connect = SQLiteConnect("./authdb")

// Set up the Authentication table
let auth = AuthAccount(connect!)
auth.setup()

// Connect the AccessTokenStore
tokenStore = AccessTokenStore(connect!)
tokenStore?.setup()

// Create HTTP server.
let server = HTTPServer()

// Register routes and handlers
let authWebRoutes = makeWebAuthRoutes()
let authJSONRoutes = makeJSONAuthRoutes("/api/v1")

// Add the routes to the server.
server.addRoutes(authWebRoutes)
server.addRoutes(authJSONRoutes)

// Add more routes here
var routes = Routes()
// routes.add(method: .get, uri: "/api/v1/test", handler: AuthHandlersJSON.testHandler)

// Add the routes to the server.
server.addRoutes(routes)

// add routes to be checked for auth
var authenticationConfig = AuthenticationConfig()
authenticationConfig.include("/api/v1/check")
authenticationConfig.exclude("/api/v1/login")
authenticationConfig.exclude("/api/v1/register")

let authFilter = AuthFilter(authenticationConfig)

// Note that order matters when the filters are of the same priority level
server.setRequestFilters([pturnstile.requestFilter])
server.setResponseFilters([pturnstile.responseFilter])

server.setRequestFilters([(authFilter, .high)])

// Set a listen port of 8181
server.serverPort = 8181

// Where to serve static files from
server.documentRoot = "./webroot"

do {
	// Launch the HTTP server.
	try server.start()
} catch PerfectError.networkError(let err, let msg) {
	print("Network error thrown: \(err) \(msg)")
}

```

### Requirements

Define the "Realm" - this is the Turnstile definition of how the authentication is handled. The implementation is specific to the SQLite datasource, although it is very similar between datasources and is designed to be generic and extendable.

``` swift 
let pturnstile = TurnstilePerfectRealm()
```

Define the location and name of the SQLite3 database:

``` swift
connect = SQLiteConnect("./authdb")
```

Define, and initialize up the authentication table:

``` swift 
let auth = AuthAccount(connect!)
auth.setup()
```

Connect the AccessTokenStore:

``` swift
tokenStore = AccessTokenStore(connect!)
tokenStore?.setup()
```

Create the HTTP Server:

``` swift
let server = HTTPServer()
```

Register routes and handlers and add the routes to the server:

``` swift 
let authWebRoutes = makeWebAuthRoutes()
let authJSONRoutes = makeJSONAuthRoutes("/api/v1")

server.addRoutes(authWebRoutes)
server.addRoutes(authJSONRoutes)
```

Add routes to be checked for authentication:

``` swift
var authenticationConfig = AuthenticationConfig()
authenticationConfig.include("/api/v1/check")
authenticationConfig.exclude("/api/v1/login")
authenticationConfig.exclude("/api/v1/register")

let authFilter = AuthFilter(authenticationConfig)
```

These routes can be either seperate, or as an array of strings. They describe inclusions and exclusions. In a forthcoming release wildcard routes will be supported.

Add request & response filters. Note the order which you specify filters that are of the same priority level:

``` swift
server.setRequestFilters([pturnstile.requestFilter])
server.setResponseFilters([pturnstile.responseFilter])

server.setRequestFilters([(authFilter, .high)])
```

Now, set the port, static files location, and start the server:

``` swift
// Set a listen port of 8181
server.serverPort = 8181

// Where to serve static files from
server.documentRoot = "./webroot"

do {
	// Launch the HTTP server.
	try server.start()
} catch PerfectError.networkError(let err, let msg) {
	print("Network error thrown: \(err) \(msg)")
}
```