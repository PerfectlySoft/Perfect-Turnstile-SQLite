//
//  SessionManager.swift
//  PerfectTurnstileSQLite
//
//  Created by Jonathan Guthrie on 2016-10-19.
//
//

import Foundation
import TurnstileCrypto
import Turnstile
import SQLiteStORM

/**
SQLiteSessionManager manages sessions via SQLite storage
*/
public class PerfectSessionManager: SessionManager {
	/// Dictionary of sessions
	//private var sessions = [String: String]()
	private let random: Random = URandom()

	/// Initializes the Session Manager. No config needed!
	public init() {}

	/// Creates a session for a given Subject object and returns the identifier.
	public func createSession(account: Account) -> String {
		let identifier = tokenStore?.new(account.uniqueID)
		return identifier!
	}

	/// Deletes the session for a session identifier.
	public func destroySession(identifier: String) {
		let token = AccessTokenStore(connect!)
		do {
			try token.get(identifier)
			try token.delete()
		} catch {
			print(error)
		}
		//sessions.removeValue(forKey: identifier)
	}

	/**
	Creates a Session-backed Account object from the Session store. This only
	contains the SessionID.
	*/
	public func restoreAccount(fromSessionID identifier: String) throws -> Account {
		let token = AccessTokenStore(connect!)
		do {
			try token.get(identifier)
			guard token.check()! else { throw InvalidSessionError() }
			return SessionAccount(uniqueID: token.userid)
		} catch {
			throw InvalidSessionError()
		}
	}
}
