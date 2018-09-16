//
//  ImageDetailViewModel.swift
//  FlickrDemo
//
//  Created by Philip Fryklund on 15/Sep/18.
//  Copyright © 2018 Arbitur. All rights reserved.
//

import Func





final class ImageDetailViewModel {
	
	let title: Observable<String?> = Observable(nil)
	let userProfileImageUrl: Observable<URL?> = Observable(nil)
	let userName: Observable<String> = Observable("... ...")
	let userLocation: Observable<String> = Observable("... ...")
	let uploadDate: Observable<Date?> = Observable(nil)
	
	private let photo: FlickrImageList.Photo
	
	
	init(photo: FlickrImageList.Photo) {
		self.photo = photo
		
		FlickrApi.getInfoAboutPhoto(id: photo.id, secret: photo.secret)
			.success { _, response in
				self.title.value = response.data.title
				self.userProfileImageUrl.value = response.data.owner.url
				self.userName.value = response.data.owner.name
				self.userLocation.value = response.data.owner.location
				self.uploadDate.value = response.data.uploadDate
			}
			.failure { error in
				print(error)
			}
	}
	
	
	var imageUrl: URL {
		return photo.url(size: .medium)
	}
}
