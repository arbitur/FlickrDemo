//
//  ImageDetailViewController.swift
//  FlickrDemo
//
//  Created by Philip Fryklund on 15/Sep/18.
//  Copyright © 2018 Arbitur. All rights reserved.
//

import Func





final class ImageDetailViewController: UIViewController {
	
	let scrollView = UIScrollView()
	let imageView = UIImageView()
	let overlay = ImageDetailOverlayView()
	
	var viewModel: ImageDetailViewModel!
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	
	
	@objc func dismissMe() {
		self.dismiss(animated: true, completion: nil)
	}
	
	
	@objc func didTap() {
		overlay.isDismissed.toggle()
	}
	
	@objc func didDoubleTap() {
		overlay.isDismissed = true
		
		if scrollView.zoomScale == scrollView.maximumZoomScale {
			scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
		}
		else {
			scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
		}
	}
	
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		
		imageView.setImageUrl(viewModel.imageUrl) { [weak self] result in
			switch result {
				case let .success(image): self?.imageView.image = image.resized(to: self!.view.bounds.size, scalingMode: .aspectFit)
				case let .failure(error): print(error)
			}
		}
	}
	
	
	override func loadView() {
		self.view = UIView(backgroundColor: UIColor(hex: 0x0F1022))
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		scrollView.minimumZoomScale = 1
		scrollView.maximumZoomScale = 5
		scrollView.delegate = self
		self.view.add(view: scrollView) {
			$0.edges.equalToSuperview()
		}
		
		imageView.contentMode = .scaleAspectFit
		scrollView.add(view: imageView) {
			$0.edges.equalToSuperview()
		}
		
		overlay.nameLabel.text = "Namn Namnsson"
		overlay.locationLabel.text = "Plats, land"
		
		overlay.dismissButton.addTarget(self, action: #selector(dismissMe))
		self.view.add(view: overlay) {
			$0.edges.equalToSuperview()
		}
		
		
		let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
		doubleTapGesture.numberOfTapsRequired = 2
		scrollView.addGestureRecognizer(doubleTapGesture)
		
		let scrollViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
		scrollViewTapGesture.require(toFail: doubleTapGesture)
		scrollView.addGestureRecognizer(scrollViewTapGesture)
		
		
		viewModel.title.bind { [weak self] title in
			self?.overlay.titleLabel.text = title
		}
		
		viewModel.userProfileImageUrl.bind { [weak self] url in
			guard let url = url else {
				return
			}
			
			self?.overlay.profileImage.setImageUrl(url)
		}
		
		viewModel.userName.bind { [weak self] name in
			self?.overlay.nameLabel.text = name
		}
		
		viewModel.userLocation.bind { [weak self] location in
			self?.overlay.locationLabel.text = location
		}
		
		viewModel.uploadDate.bind { [weak self] date in
			self?.overlay.dateLabel.text = date?.format(DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium)
		}
	}
}


extension ImageDetailViewController: UIScrollViewDelegate {
	
	func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
		overlay.isDismissed = true
	}
	
	func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
		overlay.isDismissed = scale > scrollView.minimumZoomScale
	}
	
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}
}
