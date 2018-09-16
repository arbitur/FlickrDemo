//
//  AppDelegate.swift
//  FlickrDemo
//
//  Created by Philip Fryklund on 15/Sep/18.
//  Copyright © 2018 Arbitur. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	/// For ease of testing different viewcontrollers
	private enum RootViewController {
		case tabBar
		case searchView
		
		var rawValue: UIViewController {
			switch self {
			case .tabBar:
				let vc = ViewControllerFactory.tabBar()
				return vc
				
			case .searchView:
				let vc = ViewControllerFactory.searchImages()
				return NavigationController(rootViewController: vc)
			}
		}
	}
	

	lazy var window: UIWindow? = {
		//TODO: Make .tabBar on release
		let rootViewController: RootViewController = .tabBar
		
		let window = UIWindow(frame: UIScreen.main.bounds)
		window.tintColor = UIColor(hex: 0x00c5ff)
		window.rootViewController = rootViewController.rawValue
		return window
	}()


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window?.makeKeyAndVisible()
		
		return true
	}
}

