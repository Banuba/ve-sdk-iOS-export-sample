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
import BanubaVideoEditorEffectsSDK

// MARK: - Video editor service initialization
extension ViewController {
  /// Initialize VideoEditorService with input params
  func initializeVideoEditorService() {
    
    // Initialize WatermarkApplicator with default video resolution
    let watermarkApplicator = WatermarkApplicator()
    
    // Put your token here
    let token = <#T##String#>
        
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
