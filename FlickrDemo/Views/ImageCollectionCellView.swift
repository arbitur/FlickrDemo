//
//  ImageSearchResultCellView.swift
//  FlickrDemo
//
//  Created by Philip Fryklund on 15/Sep/18.
//  Copyright © 2018 Arbitur. All rights reserved.
//

import UIKit





final class ImageCollectionCellView: UICollectionViewCell {
	static let reuseIdentifier: String = "cell"
	
	var imageView: UIImageView!
	
	
	
	private func initz() {
		imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		self.contentView.add(view: imageView) {
			$0.edges.equalToSuperview()
		}
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		imageView.image = nil
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initz()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initz()
	}
}
