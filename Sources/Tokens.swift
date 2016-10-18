//
//  Tokens.swift
//  PerfectTurnstileSQLite
//
//  Created by Jonathan Guthrie on 2016-10-17.
//
//

import SQLiteStORM
import StORM
import Foundation
import SwiftRandom
import Turnstile



open class AccessTokenStore : SQLiteStORM {

	var token: String = ""
	var userid: String = ""
	var created: Int = 0
	var updated: Int = 0
	var idle: Int = 86400 // 86400 seconds = 1 day

	override open func table() -> String {
		return "tokens"
	}


	// Need to do this because of the nature of Swift's introspection
	open override func to(_ this: StORMRow) {
		token		= this.data["token"] as! String
		userid		= (this.data["userid"] as! String)
		created		= this.data["created"] as! Int
		updated		= this.data["updated"] as! Int
		idle		= this.data["idle"] as! Int

	}

	func rows() -> [AccessTokenStore] {
		var rows = [AccessTokenStore]()
		for i in 0..<self.results.rows.count {
			let row = AccessTokenStore()
			row.to(self.results.rows[i])
			rows.append(row)
		}
		return rows
	}
	// Create the table if needed
	public func setup() {
		do {
			try sqlExec("CREATE TABLE IF NOT EXISTS tokens (token TEXT PRIMARY KEY NOT NULL, userid TEXT, created INTEGER, updated INTEGER, idle INTEGER)")
		} catch {
			print(error)
		}
	}


	private func now() -> Int {
		return Int(Date.timeIntervalSinceReferenceDate)
	}

	// checks to see if the token is active
	// upticks the updated int to keep it alive.
	public func check() -> Bool? {
		if (updated + idle) < now() { return false } else {
			do {
				updated = now()
				try save()
			} catch {
				print(error)
			}
			return true
		}
	}

	public func new(_ u: String) -> String {
		let rand = URandom()
		token = rand.secureToken
		userid = u
		created = now()
		updated = now()
		do {
			try create()
		} catch {
			print(error)
		}
		return token
	}
}
