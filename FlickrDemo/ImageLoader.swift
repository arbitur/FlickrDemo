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
//		var listeners: [Listener]
		var listener: Listener
		
		fileprivate func broadcast(result: Result<UIImage>) {
//			listeners.forEach {
//				$0(result)
//			}
			listener(result)
		}
		
		init(url: URL, listener: @escaping Listener) {
			self.url = url
//			self.listeners = [listener]
			self.listener = listener
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
//			task.listeners.append(completion)
			task.listener = completion
		}
		else {
			print("Download new task", url)
			let task = DownloadTask(url: url, listener: completion)
			
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
