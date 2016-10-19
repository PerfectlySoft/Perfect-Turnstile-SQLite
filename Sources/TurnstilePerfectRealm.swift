//
//  TurnstilePerfectSQLite.swift
//  PerfectTurnstileSQLite
//
//  Created by Jonathan Guthrie on 2016-10-17.
//
//

import Turnstile
import TurnstileWeb
import TurnstilePerfect
import PerfectHTTP

public class TurnstilePerfectRealm {
	public var requestFilter: (HTTPRequestFilter, HTTPFilterPriority)
	public var responseFilter: (HTTPResponseFilter, HTTPFilterPriority)

	private let turnstile: Turnstile
	//MemorySessionManager
	public init(sessionManager: SessionManager = PerfectSessionManager(), realm: Realm = AuthRealm()) {
		turnstile = Turnstile(sessionManager: sessionManager, realm: realm)
		let filter = TurnstileFilter(turnstile: turnstile)

		// Not sure how polymorphicism works with tuples, but the compiler was crashing on me
		// So I did this
		requestFilter = (filter, HTTPFilterPriority.high)
		responseFilter = (filter, HTTPFilterPriority.high)
	}
}
