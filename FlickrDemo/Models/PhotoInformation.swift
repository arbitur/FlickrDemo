//
//  PhotoInformation.swift
//  FlickrDemo
//
//  Created by Philip Fryklund on 15/Sep/18.
//  Copyright © 2018 Arbitur. All rights reserved.
//

import Func





struct PhotoInformation {
	
	struct Owner {
		
		let id: String
		let name: String
		let location: String
		let farm: Int
		let server: Int
		
		var url: URL {
			return URL(string: "https://farm\(farm).staticflickr.com/\(server)/buddyicons/\(id).jpg")!
		}
	}
	
	let id: Int
	let uploadDate: Date
	let title: String
	let description: String
	let numberOfViews: Int
	let owner: Owner
}


extension PhotoInformation: Func.Decodable {
	
	init(json: Dict) throws {
		id = try json.decode("photo.id")
		let timestamp: UInt = try json.decode("photo.dateuploaded")
		uploadDate = Date(timeIntervalSince1970: Double(timestamp))
		title = try json.decode("photo.title._content")
		description = try json.decode("photo.description._content")
		numberOfViews = try json.decode("photo.views")
		owner = try json.decode("photo.owner")
	}
}


extension PhotoInformation.Owner: Func.Decodable {
	
	init(json: Dict) throws {
		id = try json.decode("nsid")
		name = try json.decode("realname")
		location = try json.decode("location")
		farm = try json.decode("iconfarm")
		server = try json.decode("iconserver")
	}
}
