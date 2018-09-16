//
//  ResponseDecoding.swift
//  TidyClient
//
//  Created by Philip Fryklund on 13/Feb/18.
//  Copyright © 2018 Philip Fryklund. All rights reserved.
//

import Func





protocol ResponseDecoder {
	
	func _decode(_ data: Data) throws -> Any
}

extension ResponseDecoder {
	
	/// Decode any models
	func decode <T> (_ data: Data) throws -> T {
		let obj = try _decode(data)
		guard let model = obj as? T else {
			throw CustomError.customError("Response was of wrong format.")
		}
		return model
	}
	
	
	/// Decode Decodable models
	func decode <T: Func.Decodable> (_ data: Data) throws -> T {
		let json: Dict = try decode(data)
		return try T.init(json: json)
	}
	
	
	// Decode Response<Decodable> models
	func decodee <T: Func.Decodable> (_ data: Data) throws -> FlickrResponse<T> {
		let json: Dict = try decode(data)
		let model = try FlickrResponse<T>.init(json: json)
		if model.data == nil {
			throw CustomError.customError(model.message ?? CustomError.unknown.localizedDescription)
		}
		return model
	}
	
	
	/// Decode Response<[Decodable]> models
	func decodee <T: RangeReplaceableCollection> (_ data: Data) throws -> FlickrResponse<T> where T.Element: Func.Decodable {
		let json: Dict = try decode(data)
		let model = try FlickrResponse<T>.init(json: json)
		if model.data == nil {
			throw CustomError.customError(model.message ?? CustomError.unknown.localizedDescription)
		}
		return model
	}
}




struct JSONResponseDecoder: ResponseDecoder {
	
	func _decode(_ data: Data) throws -> Any {
		return try JSONSerialization.jsonObject(with: data, options: [])
	}
}



struct PropertyListResponseDecoder: ResponseDecoder {
	
	func _decode(_ data: Data) throws -> Any {
		return try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
	}
}

