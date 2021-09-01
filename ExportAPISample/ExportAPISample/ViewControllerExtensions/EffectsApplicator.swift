//
//  OverlayEffectsApplicator.swift
//  ExportAPISample
//
//  Created by Gleb Markin on 1.09.21.
//

import Foundation
import UIKit

// Banuba Modules
import BanubaVideoEditorEffectsSDK

// MARK: - Gif and Text Helpers
extension ViewController {
  /// Apply text effect
  func applyEffect(withType type: EffectApplicatorType) {
    guard let videoEditorService = videoEditorService else {
      return
    }
    
    // Ouput image should be created from cgImage reference
    let image = type == .gif ? createGifImage() : createTextImage()
    guard let outputImage = image else {
      return
    }
        
    // Effect Applicator
    let effectApplicator = EffectApplicator(editor: videoEditorService)
    
    // Create required effect settings
    let info = createEffectInfo(withImage: outputImage, for: type)
    
    // Apply effect
    effectApplicator.applyEffectType(.gif, effectInfo: info)
  }

  // MARK: - VideoEditorEffectInfo helper
  /// Create VideoEditorEffectInfo instance
  private func createEffectInfo(
    withImage image: UIImage,
    for type: EffectApplicatorType
  ) -> VideoEditorEffectInfo {
    
    // Relevant screen points
    let points = type == .gif ? gifImagePoints : textImagePoints
    
    // Result effect info
    let effectInfo = VideoEditorEffectInfo(
      id: UInt.random(in: 0...1000),
      image: image,
      relativeScreenPoints: points,
      start: .zero,
      end: .indefinite
    )
    
    return effectInfo
  }
  
  // MARK: - ImagePoints helpers
  /// Gif image points
  var gifImagePoints: ImagePoints {
    ImagePoints(
      leftTop: CGPoint(x: 0.15, y: 0.45),
      rightTop: CGPoint(x: 0.8, y: 0.45),
      leftBottom: CGPoint(x: 0.15, y: 0.55),
      rightBottom: CGPoint(x: 0.8, y: 0.55)
    )
  }
  
  /// Text image points
  var textImagePoints: ImagePoints {
    ImagePoints(
      leftTop: CGPoint(x: 0.15, y: 0.25),
      rightTop: CGPoint(x: 0.8, y: 0.25),
      leftBottom: CGPoint(x: 0.15, y: 0.35),
      rightBottom: CGPoint(x: 0.8, y: 0.35)
    )
  }
}
