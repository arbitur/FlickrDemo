//
//  RequestConstructing.swift
//  TidyClient
//
//  Created by Philip Fryklund on 13/Feb/18.
//  Copyright © 2018 Philip Fryklund. All rights reserved.
//

import Func





enum HTTPMethod: String {
	case get     = "GET"
	case post    = "POST"
	case put     = "PUT"
	case patch   = "PATCH"
	case delete  = "DELETE"
	case head    = "HEAD"
	case options = "OPTIONS"
	case trace   = "TRACE"
	case connect = "CONNECT"
}





//protocol RequestConstructable: class {
//
//	var method: HTTPMethod { get set }
//	var url: String { get set }
//	var headers: [String: String]? { get set }
//	var parameters: [String: Any]? { get set }
//	var parameterEncoder: RequestEncoder { get set }
//	var body: Data? { get set }
//}


final class RequestConstructor<T> {
	
	var method: HTTPMethod = .get
	var api: String = ""
	var url: String = "rest"
	var headers: [String: String]?
	var parameters: [String: Any]?
	var parameterEncoder: RequestEncoder = URLRequestEncoder.default
	var responseDecoder: ResponseDecoder = JSONResponseDecoder()
	var body: Data?
}
