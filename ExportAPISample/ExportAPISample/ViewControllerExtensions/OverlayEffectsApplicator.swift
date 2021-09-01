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
  /// Allows you to apply text/gif effect
  func applyOverlayEffect(type: EffectApplicatorType) {
    guard let videoEditorService = videoEditorService else {
      return
    }
    
    // Ouput image should be created from cgImage reference
    let outputImage = UIImage(cgImage: <#T##CGImage#>)
        
    // Effect Applicator
    let effectApplicator = EffectApplicator(editor: videoEditorService)
    
    // Create required effect settings
    let info = VideoEditorEffectInfo(
      id: UInt.random(in: 0...1000),
      image: outputImage,
      relativeScreenPoints: ImagePoints(
        leftTop: CGPoint(x: 0.15, y: 0.45),
        rightTop: CGPoint(x: 0.8, y: 0.45),
        leftBottom: CGPoint(x: 0.15, y: 0.55),
        rightBottom: CGPoint(x: 0.8, y: 0.55)
      ),
      start: .zero,
      end: .indefinite
    )
    
    // Apply effect
    effectApplicator.applyEffectType(type, effectInfo: info)
  }
}
