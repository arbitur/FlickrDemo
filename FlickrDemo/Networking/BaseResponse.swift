//
//  BaseResponse.swift
//  TidyClient
//
//  Created by Philip Fryklund on 26/Feb/18.
//  Copyright © 2018 Philip Fryklund. All rights reserved.
//

import Func





//private func errorMessage(from json: Dict) -> String? {
//	let error: String? = try? json.decode("error")
//	return error
//}





protocol Response: Func.Decodable {
	
	associatedtype T
	var data: T! { get }
//	var status: String? { get }
	var message: String? { get }
}



struct FlickrResponse <T> : Response {
	
	let data: T!
	let message: String?
//	let error: String?
}

extension FlickrResponse {

	init(json: Dict) throws {
		if let data: T = json as? T {
			self.data = data
		}
		else {
			data = nil
		}
		message = try? json.decode("message")
	}
}

extension FlickrResponse where T: Func.Decodable {
	
	init(json: Dict) throws {
		do {
			data = try T(json: json)
			message = try? json.decode("message")
		}
		catch {
			data = nil
			message = error.localizedDescription
		}
	}
}

//extension FlickrResponse where T: RangeReplaceableCollection, T.Element: Func.Decodable {
//
//	init(json: Dict) throws {
//		do {
//			data = try T(json: json)
//			message = try? json.decode("message")
//		}
//		catch {
//			data = nil
//			message = error.localizedDescription
//		}
//	}
//}


