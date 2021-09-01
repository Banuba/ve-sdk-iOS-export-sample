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
    let watermarkApplicator = WatermarkApplicator(
      videoSize: VideoResolution.hd1920x1080.size
    )
    
    // Get VideoEditorService instance via VideoEditorServiceBuilder
    videoEditorService = VideoEditorServiceBuilder.getNewEditorServicing(
      // Put your token here
      token: <#T##String#>,
      watermarkApplicator: watermarkApplicator
    )
  }
}
