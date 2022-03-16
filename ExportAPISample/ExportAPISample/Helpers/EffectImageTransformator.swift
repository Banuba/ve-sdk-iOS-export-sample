//
//  EffectImageTransformator.swift
//  ExportAPISample
//
//  Created by Gleb Markin on 1.09.21.
//

import Foundation
import UIKit

// Banuba modules
import VEEffectsSDK

// MARK: - Transformation helpers
extension ViewController {
  // MARK: - Text Image
  /// Create text image
  func createTextImage() -> UIImage?{
    // Background creation
    let height = 40
    let width = 120
    
    let numComponents = 3
    let numBytes = height * width * numComponents
    
    let pixelData = [UInt8](repeating: 210, count: numBytes)
    let colorspace = CGColorSpaceCreateDeviceRGB()
    
    let rgbData = CFDataCreate(nil, pixelData, numBytes)!
    let provider = CGDataProvider(data: rgbData)!
    
    let rgbImageRef = CGImage(
      width: width,
      height: height,
      bitsPerComponent: 8,
      bitsPerPixel: 8 * numComponents,
      bytesPerRow: width * numComponents,
      space: colorspace,
      bitmapInfo: CGBitmapInfo(rawValue: 0),
      provider: provider,
      decode: nil,
      shouldInterpolate: true,
      intent: CGColorRenderingIntent.defaultIntent
    )!
    
    let image = UIImage(cgImage: rgbImageRef)
    
    // Text creation
    UIGraphicsBeginImageContext(image.size)
    
    let text = "Hello world!"
    let rect = CGRect(origin: .zero, size: image.size)
    image.draw(in: rect)
    
    let font = UIFont(name: "Helvetica-Bold", size: 14)!
    let textColor = UIColor.white
    let textStyle = NSMutableParagraphStyle()
    textStyle.alignment = .center
    
    let attributes = [
      NSAttributedString.Key.font: font,
      NSAttributedString.Key.paragraphStyle: textStyle,
      NSAttributedString.Key.foregroundColor: textColor
    ]
    
    let textHeight = font.lineHeight
    let textY = (image.size.height - textHeight) / 2
    let textRect = CGRect(
      x: .zero,
      y: textY,
      width: image.size.width,
      height: textHeight
    )
    
    text.draw(in: textRect.integral, withAttributes: attributes)
    let result = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    return result
  }
  
  // MARK: - Gif image
  /// Create gif from sample resource
  func createGifImage() -> UIImage? {
    guard let path = Bundle.main.path(forResource: "GifExample", ofType: "gif") else {
      print("Gif does not exist at that path")
      return nil
    }
    
    let url = URL(fileURLWithPath: path)
    guard let gifData = try? Data(contentsOf: url),
          let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else {
      return nil
    }
    
    var images = [UIImage]()
    let imageCount = CGImageSourceGetCount(source)
    for i in 0 ..< imageCount {
      if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
        images.append(UIImage(cgImage: image))
      }
    }
    
    let gifImage = UIImage.animatedImage(with: images, duration: 0.4)
    
    return gifImage
  }
}
