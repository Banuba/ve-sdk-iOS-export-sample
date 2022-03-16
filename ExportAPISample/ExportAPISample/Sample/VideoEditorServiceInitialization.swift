//
//  VideoEditorServiceInitialization.swift
//  ExportAPISample
//
//  Created by Gleb Markin on 1.09.21.
//

import Foundation

// Banuba modules
import VideoEditor
import BanubaUtilities
import VEEffectsSDK

// MARK: - Video editor service initialization
extension ViewController {
  /// Initialize VideoEditorService with input params
  func initializeVideoEditorService() {
    
    // Initialize WatermarkApplicator with default video resolution
    let watermarkApplicator = WatermarkApplicator()
    
    // Put your token here
    let token = "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"
        
    // Get VideoEditorService instance via VideoEditorServiceBuilder
    videoEditorService = VideoEditorServiceBuilder.getNewEditorServicing(
      token: token,
      watermarkApplicator: watermarkApplicator
    )
    
    // Setups EffectApplicator service
    setupEffectApplicator(token: token)
  }
  
  /// Setups EffectApplicator service
  func setupEffectApplicator(token: String) {
    guard let videoEditorService = videoEditorService else {
      return
    }
    // Setup effects configs holder
    let effectsHolder = EditorEffectsConfigHolder(
      token: token
    )
    // Effect Applicator
    let effectApplicator = EffectApplicator(
      editor: videoEditorService,
      effectConfigHolder: effectsHolder
    )
    self.effectApplicator = effectApplicator
  }
}
