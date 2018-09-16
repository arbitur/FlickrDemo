//
//  TidyApi.swift
//  TidyClient
//
//  Created by Philip Fryklund on 8/Feb/18.
//  Copyright © 2018 Philip Fryklund. All rights reserved.
//

import Func





final class FlickrApi {
	static let shared: FlickrApi = FlickrApi()
	
	let urlSession: URLSession = URLSession.shared
	
	
	
	
	/// Request any models
	func request <T> (_ configure: (RequestConstructor<T>) -> ()) -> SessionTaskHandler<T> {
		let constructor = RequestConstructor<T>()
		configure(constructor)
		return self.request(constructor, decode: constructor.responseDecoder.decode)
	}
	
	
	/// Request Decodable models
	func request <T: Func.Decodable> (_ configure: (RequestConstructor<T>) -> ()) -> SessionTaskHandler<T> {
		let constructor = RequestConstructor<T>()
		configure(constructor)
		return self.request(constructor, decode: constructor.responseDecoder.decode)
	}
	
	
	/// Request BaseResponse<Decodable> models
	func request <T: Func.Decodable> (_ configure: (RequestConstructor<FlickrResponse<T>>) -> ()) -> SessionTaskHandler<FlickrResponse<T>> {
		let constructor = RequestConstructor<FlickrResponse<T>>()
		configure(constructor)
		return self.request(constructor, decode: constructor.responseDecoder.decodee)
	}
	
	
	/// Request BaseResponse<[]> models
	func request <T: RangeReplaceableCollection> (_ configure: (RequestConstructor<FlickrResponse<T>>) -> ()) -> SessionTaskHandler<FlickrResponse<T>> {
		let constructor = RequestConstructor<FlickrResponse<T>>()
		configure(constructor)
		return self.request(constructor, decode: constructor.responseDecoder.decode)
	}
	
	
	/// Request BaseResponse<[Decodable]> models
	func request <T: RangeReplaceableCollection> (_ configure: (RequestConstructor<FlickrResponse<T>>) -> ()) -> SessionTaskHandler<FlickrResponse<T>> where T.Element: Func.Decodable {
		let constructor = RequestConstructor<FlickrResponse<T>>()
		configure(constructor)
		return self.request(constructor, decode: constructor.responseDecoder.decodee)
	}
	
	
	
	private func request <T> (_ constructor: RequestConstructor<T>, decode: @escaping (Data) throws -> (T)) -> SessionTaskHandler<T> {
		let handler = SessionTaskHandler<T>()
		
		do {
			try constructor.parameterEncoder.encode(constructor)
		}
		catch {
			handler.onFailure?(error.localizedDescription)
			handler.onComplete?()
		}
		
		let url = URL(string: "https://api.flickr.com/services/\(constructor.url)")!
		
		var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
		urlRequest.httpMethod = constructor.method.rawValue
		urlRequest.httpBody = constructor.body
		urlRequest.setValue("\(urlRequest.httpBody?.count ?? 0)", forHTTPHeaderField: "Content-Length")
		constructor.headers?.forEach { key, value in
			urlRequest.addValue(value, forHTTPHeaderField: key)
		}
		
		let timer = DebugTimer()
		
		handler.task = urlSession.dataTask(with: urlRequest) { (data, response, error) in
			defer {
				Dispatch.main.async {
					handler.onComplete?()
				}
			}
			
			if let response = response {
				self.log(response: response, data: data, timer: timer)
			}
			
			guard let data = data else {
				Dispatch.main.async {
					let errorMessage = error?.localizedDescription ?? CustomError.unknown.localizedDescription
					handler.onFailure?(errorMessage)
					print("*** [ERROR] ***", errorMessage, ":", urlRequest.url!)
				}
				return
			}
			
			do {
				let model: T = try decode(data)
				
				Dispatch.main.async {
					let httpResponse = response as! HTTPURLResponse
					handler.onSuccess?(httpResponse.statusCode, model)
				}
			}
			catch {
				Dispatch.main.async {
					let errorMessage = error.localizedDescription
					handler.onFailure?(errorMessage)
					print("*** [ERROR] ***", errorMessage, ":", urlRequest.url!)
				}
			}
		}
		
		log(request: urlRequest)
		handler.task!.resume()
		
		return handler
	}
	
	
	
	private func log(request: URLRequest) {
		print()
		print("<--", request.httpMethod ?? "", request.url?.absoluteString ?? "")
		
		
		let headers = (request.allHTTPHeaderFields ?? [:])
		if headers.isNotEmpty {
			headers.forEach { print($0, $1) }
		}
		
		if let data = request.httpBody, let string = String(data) {
			print(string)
		}
	}
	
	
	private func log(response: URLResponse, data: Data?, timer: DebugTimer) {
		print()
		
		switch response {
		case let r as HTTPURLResponse:
			print("-->", r.statusCode, r.url?.absoluteString ?? "", "|", timer.formatMilli(), "|")
//			r.allHeaderFields.forEach { print($0, $1) }
			
		default:
			print("-->", response.url?.absoluteString ?? "", "|", timer.formatMilli(), "|")
		}
		
		if let data = data, let string = String(data) {
			print(string)
		}
	}
}





final class SessionTaskHandler <T> {
	
	fileprivate var onSuccess: ((Int, T) -> ())?
	fileprivate var onFailure: ((String) -> ())?
	fileprivate var onComplete: (() -> ())?
	
	fileprivate var task: URLSessionTask?
	
	
	@discardableResult
	func success(_ success: @escaping ((Int, T) -> ())) -> Self {
		self.onSuccess = success
		return self
	}
	
	@discardableResult
	func failure(_ failure: @escaping ((String) -> ())) -> Self {
		self.onFailure = failure
		return self
	}
	
	@discardableResult
	func complete(_ complete: @escaping (() -> ())) -> Self {
		self.onComplete = complete
		return self
	}
	
	
	func resume() {
		task?.resume()
	}
	
	func suspend() {
		task?.suspend()
	}
	
	func cancel() {
		task?.cancel()
	}
	
	init() {}
}


//extension SessionTaskHandler where T: Response {
//
//	convenience init <U> (_ taskHandler: SessionTaskHandler<U>) where U: Response {
//		self.init()
//
//		taskHandler.success {
//			let br = T.init(data: $1.data as? T.DataType, message: $1.message, error: $1.error, isSuccessful: $1.isSuccessful, session: $1.session)
//			self.onSuccess?($0, br)
//		}
//		taskHandler.failure {
//			self.onFailure?($0)
//		}
//		taskHandler.complete {
//			self.onComplete?()
//		}
//		self.task = taskHandler.task
//	}
//}





enum CustomError: LocalizedError {
	case unknown
	case customError(String)
	
	var errorDescription: String? {
		switch self {
			case .unknown: return "Okänt felmeddelande"
			case .customError(let e): return e
		}
	}
}




protocol TypeConvertible {
	init?(_ text: String)
	init(_ nsNumber: NSNumber)
}

extension Int: TypeConvertible {}
extension UInt: TypeConvertible {}
extension Float: TypeConvertible {}
extension Double: TypeConvertible {}
extension Bool: TypeConvertible {
	
	init?(_ text: String) {
		if let nr = Int(text) {
			self = Bool(nr)
		}
		else if text.lowercased() == "true" {
			self = true
		}
		else if text.lowercased() == "false" {
			self = false
		}
		else {
			return nil
		}
	}
}


extension Dictionary where Key == String {
	
	func decode <T: TypeConvertible> (_ key: String) throws -> T {
		if let str: String = try? self.decode(key) {
			return T(str)!
		}
		else if let nsNumber: NSNumber = self.valueFor(path: key) {
			return T(nsNumber)
		}
		else if let value: T = self.valueFor(path: key) {
			return value
		}
		else {
			throw DecodingError.missingKey(key: key)
		}
	}
}


















