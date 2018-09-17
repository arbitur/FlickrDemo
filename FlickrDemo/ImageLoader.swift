//
//  ImageDownloader.swift
//  FlickrDemo
//
//  Created by Philip Fryklund on 15/Sep/18.
//  Copyright © 2018 Arbitur. All rights reserved.
//

import Func





final class ImageLoader {
	
	final class DownloadTask {
		
		let url: URL
		typealias Listener = (Result<UIImage>) -> ()
		var listeners: [Listener]
		
		fileprivate func broadcast(result: Result<UIImage>) {
			listeners.forEach {
				$0(result)
			}
		}
		
		init(url: URL, listener: @escaping Listener) {
			self.url = url
			self.listeners = [listener]
		}
		
		deinit {
			Debug.printDeinit(self)
		}
	}
	
	static let `default` = ImageLoader()
	
	private let session: URLSession
	private var tasks = [URL: DownloadTask]()
	private let cache = NSCache<NSString, UIImage>()
	
	
	init() {
		session = URLSession.shared
	}
	
	
	subscript (_ url: URL) -> UIImage? {
		return cache.object(forKey: NSString(string: url.absoluteString))
	}
	
	
	func retreiveImage(for url: URL, completion: @escaping DownloadTask.Listener) {
		if let image = self[url] {
			print("Retreived from cache", url)
			completion(.success(image))
		}
		else if let task = tasks[url] {
			print("Joined another task")
			task.listeners ++= completion
		}
		else {
			print("Download new task", url)
			let task = DownloadTask(url: url, listener: completion)
			tasks[url] = task
			
			session.dataTask(with: url) { (data, response, error) in
				defer { self.tasks.removeValue(forKey: url) }
				guard let data = data, let image = UIImage(data: data) else {
					Dispatch.main.async {
						task.broadcast(result: .failure((error ?? CustomError.unknown).localizedDescription))
					}
					return
				}
				
				self.cache.setObject(image, forKey: NSString(string: url.absoluteString))
				
				Dispatch.main.async {
					task.broadcast(result: .success(image))
				}
			}.resume()
		}
	}
}





private var UIImageViewImageUrlKey: Void?

extension UIImageView {
	
	func setImageUrl(_ url: URL, completion: ImageLoader.DownloadTask.Listener? = nil) {
		self.imageUrl = url
		
		ImageLoader.default.retreiveImage(for: url) { result in
			guard self.imageUrl == url else {
				return
			}
			
			if let completion = completion {
				completion(result)
			}
			else {
				switch result {
				case let .success(image):
					self.image = image
					
				case let .failure(error):
					print(error)
				}
			}
		}
	}
	
	
	var imageUrl: URL? {
		get {
			return objc_getAssociatedObject(self, &UIImageViewImageUrlKey) as? URL
		}
		set {
			objc_setAssociatedObject(self, &UIImageViewImageUrlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
}
