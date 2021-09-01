//
//  ExportFunctionality .swift
//  ExportAPISample
//
//  Created by Gleb Markin on 1.09.21.
//

import Foundation

// Banuba Modules
import VideoEditor
import BanubaVideoEditorEffectsSDK

// MARK: - Export Helpers
extension ViewController {
  func exportVideo(videoFileURL: URL) {
    guard let videoEditorService = self.videoEditorService else {
      return
    }
    
    // Get sequence folder url
    let folderURL = prepareSequenceFolderURL()
    
    // Add video to the sequence
    let videoSequence = VideoSequence(folderURL: folderURL)
    videoSequence.addVideo(at: videoFileURL)
    
    // Get video resolution configuration
    let videoResolutionConfiguration = prepareVideoResolutionConfiguration()
    
    // Create VideoEditorAsset from relevant sequence
    let videoEditorAsset = VideoEditorAsset(
      sequence: videoSequence,
      isGalleryAssets: true,
      isSlideShow: false,
      videoResolutionConfiguration: videoResolutionConfiguration
    )
    
    // Set cuurent video asset to video editor service
    videoEditorService.setCurrentAsset(videoEditorAsset)

    // Expected non-zero video aspect ratio constructor. Apply transform effect after adding required asset.
    let transformApplicator = TransformEffectApplicator(editor: videoEditorService)
    // Apply temporary original rotation.
    let originalRotation: AssetRotation = .rotate90
    transformApplicator.addTransformEffect(atStartTime: .zero, end: .indefinite, rotation: originalRotation)
        
    // Apply gif effect after transforming and adding relevant video editor asset
    applyEffect(withType: .gif)
    applyEffect(withType: .text)
    
    // Get file url
    let fileURL = prepareVideoFileURL()
    
    // Export settings
    let exportVideoInfo = ExportVideoInfo(
      resolution: .fullHd1080,
      useHEVCCodecIfPossible: true
    )
    
    // Export video
    videoEditorService.exportVideo(
      to: fileURL,
      using: exportVideoInfo,
      watermarkFilterModel: nil
    ) { success, error in
      guard success else {
        print(error?.localizedDescription as Any)
        return
      }
      self.shareResultVideo(url: fileURL)
    }
  }
}
