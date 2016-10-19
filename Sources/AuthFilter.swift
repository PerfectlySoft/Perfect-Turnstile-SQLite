//
//  AuthFilter.swift
//  PerfectTurnstileSQLite
//
//  Created by Jonathan Guthrie on 2016-10-18.
//
//

import PerfectHTTP


public struct AuthFilter: HTTPRequestFilter {
	var authenticationConfig = AuthenticationConfig()

	public init(_ cfg: AuthenticationConfig) {
		authenticationConfig = cfg
	}

	public func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> ()) {
		//print("%%%%%%%%  CHECKING NOW  %%%%%%%%")

		//		guard let denied = authenticationConfig.denied else {
		//			callback(.continue(request, response))
		//			return
		//		}

		if authenticationConfig.inclusions.contains(request.path) &&
			!authenticationConfig.exclusions.contains(request.path) {
			//print("PERFORM AUTH")
			if request.user.authenticated {
				//print("AUTH OK")
				callback(.continue(request, response))
			} else {
				//print("AUTH NOT OK, booting")
				response.status = .unauthorized
				callback(.halt(request, response))
			}
		}
		callback(.continue(request, response))
	}
}
