//
//  ImageDetailOverlayView.swift
//  FlickrDemo
//
//  Created by Philip Fryklund on 15/Sep/18.
//  Copyright © 2018 Arbitur. All rights reserved.
//

import Func





final class ImageDetailOverlayView: UIView {
	override class var layerClass: AnyClass { return LinearGradientLayer.self }
	
	var gradientLayer: LinearGradientLayer {
		return self.layer as! LinearGradientLayer
	}
	
	let dismissButton = RoundButton(type: .system)
	let titleLabel = UILabel(font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.black), color: .white, alignment: .left, lines: 0)
	let profileImage = RoundImageView()
	let nameLabel = UILabel(font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.heavy), color: .white, alignment: .left, lines: 1)
	let locationLabel = UILabel(font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light), color: .white, alignment: .left, lines: 1)
	let dateLabel = UILabel(font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light), color: .white, alignment: .left, lines: 1)
	
	
	var isDismissed: Bool = false {
		willSet {
			guard newValue != isDismissed else {
				return
			}
			
			if !newValue {
				self.isHidden = false
			}
			
			UIView.animate(withDuration: 0.2,
				animations: {
					self.alpha = newValue ? 0 : 1
				},
				completion: { _ in
					self.isHidden = newValue
				})
		}
	}
	
	
	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		let view = super.hitTest(point, with: event)
		return view == self ? nil : view
	}
	
	
	
	private func initz() {
		self.gradientLayer.gradientColorSpecifications = [
			(UIColor.black.alpha(0.4), 0),
			(UIColor.black.alpha(0.05), 0.5),
			(UIColor.black.alpha(0.4), 1)
		]
		
		self.isOpaque = false
		self.layoutMargins = UIEdgeInsets(inset: 16)
		
		dismissButton.setImage(#imageLiteral(resourceName: "close"), for: .normal)
		dismissButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		self.add(view: dismissButton) {
			$0.top.equalTo(self.safeAreaLayoutGuide.lac.top, constant: self.layoutMargins)
			$0.right.equalTo(self.safeAreaLayoutGuide.lac.right, constant: -self.layoutMargins.right)
			$0.size.equalTo(44)
		}
		
		let userContentStack = UIStackView(axis: .horizontal)
		userContentStack.spacing = 8
		self.add(view: userContentStack) {
			$0.left.equalTo(self.safeAreaLayoutGuide.lac.left, constant: self.layoutMargins)
			$0.right.lessThan(self.safeAreaLayoutGuide.lac.right, constant: -self.layoutMargins.right)
			$0.bottom.equalTo(self.safeAreaLayoutGuide.lac.bottom, constant: self.layoutMargins)
		}
		
		profileImage.contentMode = .scaleAspectFill
		userContentStack.add(arrangedView: profileImage) {
			$0.aspectRatio()
		}
		
		let labelsContentStack = UIStackView(arrangedSubviews: [nameLabel, locationLabel, dateLabel])
		labelsContentStack.axis = .vertical
		labelsContentStack.spacing = 8
		userContentStack.addArrangedSubview(labelsContentStack)
		
		self.add(view: titleLabel) {
			$0.bottom.greaterThan(dismissButton.lac.bottom, constant: self.layoutMargins.top)
			$0.left.equalTo(self.safeAreaLayoutGuide.lac.left, constant: self.layoutMargins)
			$0.right.lessThan(self.safeAreaLayoutGuide.lac.right, constant: -self.layoutMargins.right)
			$0.bottom.equalTo(userContentStack.lac.top, constant: -self.layoutMargins.bottom)
		}
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
