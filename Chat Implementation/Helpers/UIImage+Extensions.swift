//
//  UIImage+Extensions.swift
//  Chat Implementation
//
//  Created by Arthur Avagyan on 14.04.24.
//

import UIKit

extension UIImage {
	
	func resizeImage(targetSize: CGSize) -> UIImage {
		guard targetSize.width > 0, targetSize.height > 0 else { return self }
		let size = self.size
		
		let widthRatio  = targetSize.width  / size.width
		let heightRatio = targetSize.height / size.height
		
		// Figure out what our orientation is, and use that to form the rectangle
		var newSize: CGSize // = CGSize(width: size.width * widthRatio, height: size.height * heightRatio)
		if(widthRatio > heightRatio) {
			newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
		} else {
			newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
		}
		
		// This is the rect that we've calculated out and this is what is actually used below
		let rect = CGRect(origin: .zero, size: newSize)
		
		// Actually do the resizing to the rect using the ImageContext stuff
		UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
		self.draw(in: rect)
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return newImage ?? self
	}

}
