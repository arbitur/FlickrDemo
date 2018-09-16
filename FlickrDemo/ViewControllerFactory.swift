//
//  ViewControllerFactory.swift
//  FlickrDemo
//
//  Created by Philip Fryklund on 15/Sep/18.
//  Copyright © 2018 Arbitur. All rights reserved.
//

import Func





enum ViewControllerFactory {
	
	static func tabBar() -> UIViewController {
		let tabVc = TabBarController()
		return tabVc
	}
	
	
	static func recentImages() -> UIViewController {
		let vc = RecentImageCollectionViewController()
		vc.viewModel = RecentImageCollectionViewModel()
		return vc
	}
	
	
	static func searchImages() -> UIViewController {
		let vc = SearchImageCollectionViewController()
		vc.viewModel = SearchImageCollectionViewModel()
		return vc
	}
	
	
	static func imageDetail(photo: FlickrImageList.Photo) -> UIViewController {
		let vc = ImageDetailViewController()
		vc.viewModel = ImageDetailViewModel(photo: photo)
		return vc
	}
}
