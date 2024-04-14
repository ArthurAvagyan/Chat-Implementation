////
////  FFT.swift
////  Chat Implementation
////
////  Created by Arthur Avagyan on 14.04.24.
////
//
//import UIKit
//import Accelerate
//import CoreImage
//
//// Function to load image from file
//func loadImage(named name: String) -> UIImage? {
//	guard let url = Bundle.main.url(forResource: name, withExtension: nil),
//		  let data = try? Data(contentsOf: url) else {
//		return nil
//	}
//	return UIImage(data: data)
//}
//
//// Function to convert UIImage to grayscale
//func convertToGrayscale(image: UIImage) -> UIImage? {
//	let ciImage = CIImage(image: image)
//	let filter = CIFilter(name: "CIPhotoEffectMono")
//	filter?.setValue(ciImage, forKey: kCIInputImageKey)
//	if let outputCIImage = filter?.outputImage {
//		let context = CIContext(options: nil)
//		if let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) {
//			return UIImage(cgImage: outputCGImage)
//		}
//	}
//	return nil
//}
//
//// Function to perform FFT
//func performFFT(image: UIImage) -> [Float] {
//	guard let cgImage = image.cgImage else {
//		fatalError("Failed to get CGImage from UIImage")
//	}
//	
//	let width = vImagePixelCount(cgImage.width)
//	let height = vImagePixelCount(cgImage.height)
//	let bytesPerPixel = cgImage.bitsPerPixel / 8
//	let bytesPerRow = cgImage.bytesPerRow
//	let imageData = UnsafeMutablePointer<UInt8>.allocate(capacity: bytesPerRow * Int(height))
//	let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
//	
//	guard let context = CGContext(data: imageData, width: Int(width), height: Int(height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: bitmapInfo.rawValue) else {
//		fatalError("Failed to create CGContext")
//	}
//	context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
//	
//	let srcBuffer = vImage_Buffer(data: imageData, height: height, width: width, rowBytes: bytesPerRow)
//	var dstBuffer = vImage_Buffer()
//	vImageBuffer_Init(&dstBuffer, height, width, 8, vImage_Flags(kvImageNoFlags))
//	
//	vImageConvert_Planar8toPlanarF(&srcBuffer, &dstBuffer, 0)
//	
//	let fftSetup = vDSP_create_fftsetup(vDSP_Length(log2(Float(width))), FFTRadix(kFFTRadix2))!
//	
//	var splitComplex = DSPSplitComplex(realp: UnsafeMutablePointer<Float>(bitPattern: dstBuffer.data.assumingMemoryBound(to: Float.self)), imagp: UnsafeMutablePointer<Float>.allocate(capacity: Int(height * width)))
//	
//	vDSP_fft2d_zrop(fftSetup, &splitComplex, 1, 0, vDSP_Length(log2(Float(height))), vDSP_Length(log2(Float(width))), FFTDirection(FFT_FORWARD))
//	
//	var magnitudes = [Float](repeating: 0.0, count: Int(height * width))
//	vDSP_zvmags(&splitComplex, 1, &magnitudes, 1, vDSP_Length(height * width))
//	
//	vDSP_destroy_fftsetup(fftSetup)
//	
//	return magnitudes
//}
//
//// Function to apply blur in frequency domain
//func applyBlurInFrequencyDomain(magnitudes: inout [Float], width: Int, height: Int, blurRadius: Float) {
//	let halfWidth = width / 2
//	let halfHeight = height / 2
//	
//	for y in 0..<height {
//		for x in 0..<width {
//			let distanceFromCenter = sqrt(pow(Float(x - halfWidth), 2) + pow(Float(y - halfHeight), 2))
//			let gaussian = exp(-(distanceFromCenter * distanceFromCenter) / (2 * blurRadius * blurRadius))
//			magnitudes[y * width + x] *= gaussian
//		}
//	}
//}
//
//// Function to perform inverse FFT
//func performInverseFFT(magnitudes: inout [Float], width: Int, height: Int) -> UIImage? {
//	let fftSetup = vDSP_create_fftsetup(vDSP_Length(log2(Float(width))), FFTRadix(kFFTRadix2))!
//	
//	var splitComplex = DSPSplitComplex(realp: UnsafeMutablePointer<Float>(&magnitudes), imagp: UnsafeMutablePointer<Float>.allocate(capacity: Int(height * width)))
//	
//	vDSP_fft2d_zrop(fftSetup, &splitComplex, 1, 0, vDSP_Length(log2(Float(height))), vDSP_Length(log2(Float(width))), FFTDirection(FFT_INVERSE))
//	
//	var outputBuffer = vImage_Buffer(data: splitComplex.realp, height: vImagePixelCount(height), width: vImagePixelCount(width), rowBytes: width * MemoryLayout<Float>.size)
//	
//	let outputCGImage = vImageCreateCGImageFromBuffer(&outputBuffer, &outputBuffer.format, nil, nil, vImage_Flags(kvImageNoAllocate), nil)?.takeRetainedValue()
//	
//	vDSP_destroy_fftsetup(fftSetup)
//	
//	if let cgImage = outputCGImage {
//		return UIImage(cgImage: cgImage)
//	} else {
//		return nil
//	}
//}
//
//// Load image
//guard let inputImage = loadImage(named: "input_image.jpg") else {
//	fatalError("Failed to load input image")
//}
//
//// Convert image to grayscale
//guard let grayscaleImage = convertToGrayscale(image: inputImage) else {
//	fatalError("Failed to convert image to grayscale")
//}
//
//// Perform FFT
//var magnitudes = performFFT(image: grayscaleImage)
//
//// Apply blur in frequency domain
//let blurRadius: Float = 30.0
//applyBlurInFrequencyDomain(magnitudes: &magnitudes, width: grayscaleImage.cgImage!.width, height: grayscaleImage.cgImage!.height, blurRadius: blurRadius)
//
//// Perform inverse FFT
//guard let blurredImage = performInverseFFT(magnitudes: &magnitudes, width: grayscaleImage.cgImage!.width, height: grayscaleImage.cgImage!.height) else {
//	fatalError("Failed to perform inverse FFT")
//}
//
//// Display or save the blurred image
//// For example, you can display the blurred image in a UIImageView
//let imageView = UIImageView(image: blurredImage)
//imageView.contentMode = .scaleAspectFit
//// Add imageView to your view hierarchy
