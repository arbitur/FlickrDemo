//
//  NavigationController.swift
//  FlickrDemo
//
//  Created by Philip Fryklund on 15/Sep/18.
//  Copyright © 2018 Arbitur. All rights reserved.
//

import Func





final class NavigationController: UINavigationController {
	
	private func initz() {
		self.navigationBar.barStyle = .black
		self.navigationBar.isTranslucent = true
		self.navigationBar.prefersLargeTitles = true
	}
	
	override init(rootViewController: UIViewController) {
		super.init(rootViewController: rootViewController)
		initz()
	}
	
	override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
		super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
		initz()
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		initz()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initz()
	}
}
