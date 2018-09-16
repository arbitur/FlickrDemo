//
//  TabController.swift
//  FlickrDemo
//
//  Created by Philip Fryklund on 15/Sep/18.
//  Copyright © 2018 Arbitur. All rights reserved.
//

import Func





final class TabBarController: UITabBarController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tabBar.tintColor = .white
		self.tabBar.barStyle = .black
		self.tabBar.isTranslucent = true
		
		let recentVc = ViewControllerFactory.recentImages()
		recentVc.title = "Nya bilder"
		recentVc.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "recent").resized(to: .zero + 32), selectedImage: nil)
		
		let searchVc = ViewControllerFactory.searchImages()
		searchVc.title = "Sök"
		searchVc.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "search").resized(to: .zero + 32), selectedImage: nil)
		
		self.viewControllers = [NavigationController(rootViewController: recentVc), NavigationController(rootViewController: searchVc)]
	}
}
