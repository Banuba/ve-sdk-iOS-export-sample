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
  func applyColorEffect() {
    // Lut URL
    guard let url = Bundle.main.url(forResource: "luts/bubblegum", withExtension: "png") else {
      return
    }
    // Effect Applicator
    effectApplicator?.applyColorEffect(
      name: "BubbleGum",
      lutUrl: url,
      startTime: .zero,
      endTime: .indefinite,
      removeSameType: false,
      effectId: EffectIDs.colorEffectStartId + uniqueEffectId
    )
  }
  
  /// Apply visual effect
  func applyVisualEffect(withType type: VisualEffectApplicatorType) {
    // Effect Applicator
    effectApplicator?.applyVisualEffectApplicatorType(
      type,
      startTime: .zero,
      endTime: .indefinite,
      removeSameType: false,
      effectId: EffectIDs.visualEffectStartId + uniqueEffectId
    )
  }
  
  /// Apply speed effect
  func applySpeedEffect(withType type: SpeedEffectType) {
    // Effect Applicator
    effectApplicator?.applySpeedEffectType(
      type,
      startTime: .zero,
      endTime: .indefinite,
      removeSameType: false,
      effectId: EffectIDs.speedEffectStartId + uniqueEffectId
    )
  }
  
  /// Apply text  or gif effect
  func applyOverlayEffect(withType type: OverlayEffectApplicatorType) {
    // Ouput image should be created from cgImage reference
    let image = type == .gif ? createGifImage() : createTextImage()
    guard let outputImage = image else {
      return
    }
    // Create required effect settings
    let info = createEffectInfo(withImage: outputImage, for: type)
    
    // Apply effect
    effectApplicator?.applyOverlayEffectType(type, effectInfo: info)
  }

  // MARK: - VideoEditorEffectInfo helper
  /// Create VideoEditorEffectInfo instance
  func createEffectInfo(
    withImage image: UIImage,
    for type: OverlayEffectApplicatorType
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
  
  /// Unique effect id
  var uniqueEffectId: UInt {
    UInt.random(in: 0...100)
  }
}
