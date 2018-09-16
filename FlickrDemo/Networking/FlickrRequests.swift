//
//  Requests.swift
//  TidyClient
//
//  Created by Philip Fryklund on 13/Feb/18.
//  Copyright © 2018 Philip Fryklund. All rights reserved.
//

import Func





extension FlickrApi {
	
	static func getRecentResults(page: Int = 1) -> SessionTaskHandler<FlickrResponse<FlickrImageList>> {
		return self.shared.request {
			$0.method = .get
			$0.api = "flickr.photos.getRecent"
			$0.parameterEncoder = URLRequestEncoder.default
			$0.parameters = [
				"per_page": 20,
				"page": page
			]
		}
	}
	
	
	static func getSearchResults(query: String?, tags: [String]?, page: Int = 1) -> SessionTaskHandler<FlickrResponse<FlickrImageList>> {
		var parameters: Dict = [
			"per_page": 20,
			"page": page
		]
		if let query = query {
			parameters["text"] = query
		}
		if let tags = tags {
			parameters["tags"] = tags.joined(by: ",")
		}
		
		return self.shared.request {
			$0.method = .get
			$0.api = "flickr.photos.search"
			$0.parameterEncoder = URLRequestEncoder.default
			$0.parameters = parameters
		}
	}
	
	
	static func getInfoAboutPhoto(id: Int, secret: String) -> SessionTaskHandler<FlickrResponse<PhotoInformation>> {
		return self.shared.request {
			$0.method = .get
			$0.api = "flickr.photos.getInfo"
			$0.parameterEncoder = URLRequestEncoder.default
			$0.parameters = [
				"photo_id": id,
				"secret": secret
			]
		}
	}
}

