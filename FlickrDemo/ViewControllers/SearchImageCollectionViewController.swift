//
//  SearchImageCollectionViewController.swift
//  FlickrDemo
//
//  Created by Philip Fryklund on 15/Sep/18.
//  Copyright © 2018 Arbitur. All rights reserved.
//

import Func





final class SearchImageCollectionViewController: ImageCollectionViewController <SearchImageCollectionViewModel>, UISearchBarDelegate {
	
	let searchController = UISearchController(searchResultsController: nil)
	
	
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchController.dismiss(animated: true, completion: nil)
		
		guard let query = searchBar.text, query.isNotEmpty else {
			return
		}
		
		ActivityIndicator.show()
		
		viewModel.search(query: query) { result in
			switch result {
			case .failure(let error):
				let alert = AlertDialog(title: "Ett fel inträffade", subtitle: error)
				alert.addCancel(title: "OK")
				self.present(alert)
				fallthrough
				
			default:
				ActivityIndicator.dismiss(animated: true)
			}
		}
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		searchController.searchBar.keyboardAppearance = .dark
		searchController.searchBar.delegate = self
		self.navigationItem.searchController = searchController
		
		//TODO: Only for testing, remove in production
//		viewModel.search(query: "Cute dog", completion: { _ in })
	}
}
