//
//  AuthFilter.swift
//  PerfectTurnstileSQLite
//
//  Created by Jonathan Guthrie on 2016-10-18.
//
//

import PerfectHTTP
import SwiftString


public struct AuthFilter: HTTPRequestFilter {
	var authenticationConfig = AuthenticationConfig()

	public init(_ cfg: AuthenticationConfig) {
		authenticationConfig = cfg
	}

	public func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> ()) {
		//		guard let denied = authenticationConfig.denied else {
		//			callback(.continue(request, response))
		//			return
		//		}

		var checkAuth = false
		let wildcardInclusions = authenticationConfig.inclusions.filter({$0.contains("*")})
		let wildcardExclusions = authenticationConfig.exclusions.filter({$0.contains("*")})

		// check if specifically in inclusions
		if authenticationConfig.inclusions.contains(request.path) { checkAuth = true }
		// check if covered by a wildcard
		for wInc in wildcardInclusions {
			if request.path.startsWith(wInc.split("*")[0]) { checkAuth = true }
		}

		// ignore check if sepecified in exclusions
		if authenticationConfig.exclusions.contains(request.path) { checkAuth = false }
		// check if covered by a wildcard
		for wInc in wildcardExclusions {
			if request.path.startsWith(wInc.split("*")[0]) { checkAuth = false }
		}

		if checkAuth && request.user.authenticated {
			callback(.continue(request, response))
			return
		} else if checkAuth {
			response.status = .unauthorized
			callback(.halt(request, response))
			return
		}
		callback(.continue(request, response))
	}
}
