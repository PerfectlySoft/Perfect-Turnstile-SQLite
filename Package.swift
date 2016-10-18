//
//  Package.swift
//  PerfectTurnstileSQLite
//
//  Created by Jonathan Guthrie on 2016-10-11.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PackageDescription

let package = Package(
	name: "PerfectTurnstileSQLite",
	targets: [],
	dependencies: [
		.Package(url: "https://github.com/SwiftORM/SQLite-StORM.git", majorVersion: 0, minor: 0),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2, minor: 0),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-Mustache.git", majorVersion: 2, minor: 0),
		.Package(url: "https://github.com/iamjono/SwiftString.git",majorVersion: 1, minor: 0),
		.Package(url: "https://github.com/iamjono/SwiftRandom.git",majorVersion: 0, minor: 2),
		.Package(url: "https://github.com/PerfectSideRepos/Turnstile-Perfect.git", majorVersion:1)
	]
)
