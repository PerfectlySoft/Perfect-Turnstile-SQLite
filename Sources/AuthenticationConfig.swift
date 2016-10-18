//
//  AuthenticationConfig.swift
//  PerfectTurnstileSQLite
//
//  Created by Jonathan Guthrie on 2016-10-18.
//
//

public struct AuthenticationConfig {
	public var inclusions = [String]()
	public var exclusions = [String]()

	public var denied: String?

	public init() {}

	public mutating func include(_ str: String) {
		inclusions.append(str)
	}
	public mutating func include(_ arr: [String]) {
		inclusions += arr
	}
	public mutating func exclude(_ str: String) {
		exclusions.append(str)
	}
	public mutating func exclude(_ arr: [String]) {
		exclusions += arr
	}
}
