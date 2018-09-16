//
//  FlickrSearchResult.swift
//  FlickrDemo
//
//  Created by Philip Fryklund on 15/Sep/18.
//  Copyright © 2018 Arbitur. All rights reserved.
//

import Func





struct FlickrImageList {
	
	struct Photo {
		
		enum PictureSize: String {
			case small = "s"
			case medium = "z"
			case original = "o"
		}
		
		let id: Int
		let secret: String
		let farm: Int
		let server: Int
//		let owner: String
		let title: String
		
		func url(size: PictureSize) -> URL {
			return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_\(size.rawValue).jpg")!
		}
	}
	
	var page: Int
//	let pages: Int
//	let perPage: Int
//	let total: Int
	var photos: [Photo]
}


extension FlickrImageList: Func.Decodable {
	
	init(json: Dict) throws {
		page = try json.decode("photos.page")
//		pages = try json.decode("photos.pages")
//		perPage = try json.decode("photos.perpage")
//		total = try json.decode("photos.total")
		photos = try json.decode("photos.photo")
	}
}


extension FlickrImageList.Photo: Func.Decodable {
	
	init(json: Dict) throws {
		id = try json.decode("id")
		secret = try json.decode("secret")
		farm = try json.decode("farm")
		server = try json.decode("server")
//		owner = try json.decode("owner")
		title = try json.decode("title")
	}
}
