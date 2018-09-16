//
//  ImageSearchViewModel.swift
//  FlickrDemo
//
//  Created by Philip Fryklund on 15/Sep/18.
//  Copyright © 2018 Arbitur. All rights reserved.
//

import Func





protocol ImageCollectionViewModel: class {
	
	var numberOfImages: Observable<Int> { get }
	var results: [FlickrImageList.Photo] { get }
	
	func image(at indexPath: IndexPath) -> UIImage?
	func imageUrl(at indexPath: IndexPath) -> URL
	func imageDetailViewController(for indexPath: IndexPath) -> UIViewController
	
	func reachedEndOfResults()
}

extension ImageCollectionViewModel {
	
	private func photo(at indexPath: IndexPath) -> FlickrImageList.Photo {
		return results[indexPath.row]
	}
	
	
	func image(at indexPath: IndexPath) -> UIImage? {
		let url = imageUrl(at: indexPath)
		return ImageLoader.default[url]
	}
	
	
	func imageUrl(at indexPath: IndexPath) -> URL {
		return photo(at: indexPath).url(size: .medium)
	}
	
	
	func imageDetailViewController(for indexPath: IndexPath) -> UIViewController {
		let photo = self.photo(at: indexPath)
		let vc = ViewControllerFactory.imageDetail(photo: photo)
		return vc
	}
}





final class SearchImageCollectionViewModel: ImageCollectionViewModel {
	
	let numberOfImages: Observable<Int> = Observable(0)
	
	var results = [FlickrImageList.Photo]() {
		didSet {
			numberOfImages.value = results.count
		}
	}
	
	private var page: Int = 0
	private var _isLoading = false
	private var lastQuery: String?
	
	
	func search(query: String, completion: @escaping (Result<Void>) -> ()) {
		lastQuery = query
		
		_isLoading = true
		FlickrApi.getSearchResults(query: query, tags: nil)
			.success { _, response in
				self.page = response.data.page
				self.results = response.data.photos
				completion(.success(()))
			}
			.failure { error in
				completion(.failure(error))
			}
			.complete {
				self._isLoading = false
			}
	}
	
	
	func reachedEndOfResults() {
		guard !_isLoading, let query = lastQuery else {
			return
		}
		
		_isLoading = true
		FlickrApi.getSearchResults(query: query, tags: nil, page: page + 1)
			.success { _, response in
				self.page = response.data.page
				self.results += response.data.photos
			}
			.failure { error in
			}
			.complete {
				self._isLoading = false
			}
	}
}





final class RecentImageCollectionViewModel: ImageCollectionViewModel {
	
	let numberOfImages: Observable<Int> = Observable(0)
	
	var results = [FlickrImageList.Photo]() {
		didSet {
			numberOfImages.value = results.count
		}
	}
	
	private var page: Int = 0
	private var _isLoading = false
	
	
	init() {
		_isLoading = true
		FlickrApi.getRecentResults()
			.success { _, response in
				self.page = response.data.page
				self.results = response.data.photos
			}
			.failure { error in
			}
			.complete {
				self._isLoading = false
			}
	}
	
	
	func reachedEndOfResults() {
		guard !_isLoading else {
			return
		}
		
		_isLoading = true
		FlickrApi.getRecentResults(page: page + 1)
			.success { _, response in
				self.page = response.data.page
				self.results += response.data.photos
			}
			.failure { error in
			}
			.complete {
				self._isLoading = false
			}
	}
}
