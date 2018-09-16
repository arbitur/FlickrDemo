//
//  RequestEncoding.swift
//  TidyClient
//
//  Created by Philip Fryklund on 13/Feb/18.
//  Copyright © 2018 Philip Fryklund. All rights reserved.
//

import Func





protocol RequestEncoder {
	
	func encode <T> (_ constructor: RequestConstructor<T>) throws
}



struct URLRequestEncoder: RequestEncoder {
	static let `default` = URLRequestEncoder()
	
	
	func encode <T> (_ constructor: RequestConstructor<T>) throws {
		guard var parameters = constructor.parameters else {
			return
		}
		
		parameters["method"] = constructor.api
		parameters["api_key"] = "791f3e104f50b801f64341ebc8ac1fc2"
		parameters["format"] = "json"
		parameters["nojsoncallback"] = 1
		let query = parameters.map({ "\($0.percentEncoding(except: .alphanumerics)!)=\("\($1)".percentEncoding(except: .alphanumerics)!)" }).joined(by: "&")
		
		switch constructor.method {
		case .get, .head, .delete:
			constructor.url += "?" + query
			
		default:
			constructor.headers =  ["Content-Type": "application/x-www-form-urlencoded; charset=utf-8"] + (constructor.headers ?? [:])
			constructor.body = Data(query)
		}
	}
}



struct JSONRequestEncoder: RequestEncoder {
	static let `default` = JSONRequestEncoder()
	
	
	func encode <T> (_ constructor: RequestConstructor<T>) throws {
		guard let parameters = constructor.parameters else {
			return
		}
		
		constructor.headers =  ["Content-Type": "application/json"] + (constructor.headers ?? [:])
		constructor.body = try JSONSerialization.data(withJSONObject: parameters, options: [])
	}
}



struct FormRequestEncoder: RequestEncoder {
	
	private static let crlf = "\r\n"
	
	private struct Boundary {
		let boundary: String
		let first: String
		let middle: String
		let last: String
		
		init() {
			boundary = String(format: "tidyapp_boundary_%08x%08x", arc4random(), arc4random())
			first = "--\(boundary)\(crlf)"
			middle = "\(crlf)--\(boundary)\(crlf)"
			last = "\(crlf)--\(boundary)--\(crlf)"
		}
	}
	
	struct FormBody {
		let fileName: String?
		let mime: String?
		let data: Data
	}
	
	private let boundary = Boundary()
	
	
	
	func encode <T> (_ constructor: RequestConstructor<T>) throws {
		guard let parameters = constructor.parameters else {
			return
		}
		
		let bodies: [(name: String, body: FormBody)] = parameters.map { key, value in
			if let body = value as? FormBody {
				return (key, body)
			}
			
			return (key, FormBody(fileName: nil, mime: nil, data: Data(String(describing: value))!))
		}
		
		constructor.headers =  ["Content-Type": "multipart/form-data; boundary=\(self.boundary.boundary)"] + (constructor.headers ?? [:])
		
		var httpBody = Data()
		httpBody += Data(boundary.first)!
		
		for (name, body) in bodies {
			if name != bodies[0].name {
				httpBody += Data(boundary.middle)!
			}
			
			var disposition = "form-data; name=\"\(name)\""
			if let fileName = body.fileName {
				disposition += "; filename=\"\(fileName)\""
			}
			
			var headers = ["Content-Disposition": disposition]
			if let mime = body.mime {
				headers["Content-Type"] = mime
			}
			
			httpBody += Data( headers.map({ "\($0): \($1)\(FormRequestEncoder.crlf)" }).joined() )!
			httpBody += Data(FormRequestEncoder.crlf)!
			
			httpBody += body.data
		}
		
		httpBody += Data(boundary.last)!
		
		constructor.body = httpBody
	}
}










