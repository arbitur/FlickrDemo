//
//  ImageCollectionViewController.swift
//  FlickrDemo
//
//  Created by Philip Fryklund on 15/Sep/18.
//  Copyright © 2018 Arbitur. All rights reserved.
//

import Func





class ImageCollectionViewController <ViewModel: ImageCollectionViewModel>: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	var collectionViewLayout: UICollectionViewFlowLayout!
	var collectionView: UICollectionView!
	
//	let searchController = UISearchController(searchResultsController: nil)
	
	var viewModel: ViewModel!
	
	
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let vc = viewModel.imageDetailViewController(for: indexPath)
		self.present(vc)
	}
	
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.numberOfImages.value
	}
	
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionCellView.reuseIdentifier, for: indexPath) as! ImageCollectionCellView
		
		// To not get in an infinite loop from ImageLoader.retreiveImage
		cell.imageView.setImageUrl(viewModel.imageUrl(at: indexPath))
		return cell
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return .zero + (collectionView.bounds.width / 2 - self.collectionViewLayout.minimumInteritemSpacing)
	}
	
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView.contentOffset.y > scrollView.maximumContentOffset.y - 100 {
			viewModel.reachedEndOfResults()
		}
	}
	
	
	
	override func loadView() {
		collectionViewLayout = UICollectionViewFlowLayout()
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
		self.view = collectionView
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.hidesSearchBarWhenScrolling = false
		
		collectionView.register(ImageCollectionCellView.self, forCellWithReuseIdentifier: ImageCollectionCellView.reuseIdentifier)
		collectionView.dataSource = self
		collectionView.delegate = self
		
		let emptyLabel = UILabel(font: UIFont.systemFont(ofSize: 17, weight: .heavy), color: .white, alignment: .center, lines: 0)
		emptyLabel.text = "Inga sökresultat hittades"
		collectionView.backgroundView = emptyLabel
		collectionView.backgroundView?.isHidden = true
		
		
		viewModel.numberOfImages.bindNext { [weak self] in
			self?.collectionView.backgroundView?.isHidden = $0 > 0
			self?.collectionView.reloadData()
		}
	}
}
