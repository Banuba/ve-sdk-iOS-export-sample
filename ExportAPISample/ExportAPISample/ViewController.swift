//
//  ViewController.swift
//  ExportAPISample
//
//  Created by Gleb Markin on 31.08.21.
//

import UIKit
import AVFoundation
import Photos

// Banuba Modules
import VideoEditor
import BanubaUtilities
import BanubaVideoEditorEffectsSDK

class ViewController: UIViewController {
  
  // MARK: - Video editor service instance
  private var videoEditorService: VideoEditorService?

  override func viewDidLoad() {
    super.viewDidLoad()
    // Initialize VideoEditorService with input params
    initializeVideoEditorService()
  }
  
  // MARK: - Export Action
  @IBAction func exportButtonDidTap(sender: UIButton) {
    // Open gallery and export choosen video
    openGallery() { [weak self] videoFileURL in
      self?.exportVideo(videoFileURL: videoFileURL)
    }
  }
}

// MARK: - Video editor service initialization
extension ViewController {
  /// Initialize VideoEditorService with input params
  private func initializeVideoEditorService() {
    
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

// MARK: - Export Helpers
extension ViewController {
  private func exportVideo(videoFileURL: URL) {
    guard let videoEditorService = videoEditorService else {
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
    transformApplicator.addTransformEffect(atStartTime: .zero, end: .indefinite, rotation: .rotate90)
        
    // Apply effect after transforming and adding relevant video editor asset
    applyOverlayEffect(type: .text)
    
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

// MARK: - Gif and Text Helpers
extension ViewController {
  /// Allows you to apply text/gif effect
  private func applyOverlayEffect(type: EffectApplicatorType) {
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

// MARK: - VideoResolutionHelpers
extension ViewController {
  /// Create VideoResolutionConfiguration with required params.
  private func prepareVideoResolutionConfiguration() -> VideoResolutionConfiguration {
    VideoResolutionConfiguration(
      default: .hd1920x1080,
      resolutions: [
        .iPhone5S : .hd1280x720,
        .iPhone6: .default854x480,
        .iPhone6S: .hd1280x720,
        .iPhone6plus: .default854x480,
        .iPhone6Splus: .hd1280x720,
        .iPhoneSE: .hd1280x720,
        .iPhone5 : .hd1280x720,
      ],
      thumbnailHeights: [:],
      defaultThumbnailHeight: 400.0
    )
  }
}

// MARK: - FileManager helpers
extension ViewController {
  /// Prepare output url for video url
  private func prepareVideoFileURL() -> URL {
    let manager = FileManager.default
    let fileURL = manager.temporaryDirectory.appendingPathComponent("tmp.mov")
    if manager.fileExists(atPath: fileURL.path) {
      try? manager.removeItem(at: fileURL)
    }
    
    return fileURL
  }
  
  /// Prepare folder url for sequence container
  private func prepareSequenceFolderURL() -> URL {
    let videosDirectoryName = "Videos"
    let name = UUID().uuidString

    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let videosDirectory = documentsDirectory.appendingPathComponent(videosDirectoryName)
    
    let folderURL = videosDirectory.appendingPathComponent(name)
    
    return folderURL
  }
}

// MARK: - UIActivityViewController Helpers
extension ViewController {
  /// Share result video with UIActivityViewController
  func shareResultVideo(url: URL) {
    let shareController = UIActivityViewController(
      activityItems: [url],
      applicationActivities: nil
    )
    
    DispatchQueue.main.async {
      self.present(
        shareController,
        animated: true
      )
    }
  }
}

// MARK: - BSImagePicker gallery helper
extension ViewController {
  /// Allows you to open gallery and get choosen asset via completion. Video picker entity based on third party library BSImagePicker.
  private func openGallery(completion: @escaping (URL) -> Void) {
    VideoPicker().pickVideo(
      isMultipleSelectionEnabled: false,
      from: self
    ) { assets in
      
      guard let assets = assets else {
        return
      }
      
      var resultUrls: [URL] = []
      let group = DispatchGroup()
      var exportVideoRequests = assets.count
      assets.forEach { asset in
        group.enter()
        PHImageManager.default().requestAVAsset(
          forVideo: asset,
          options: .none
        ) { (asset, _, _) in
          
          guard let asset = asset else { return }
          
          let groupHandler = {
            exportVideoRequests -= 1
            group.leave()
          }
          
          if let urlAsset = asset as? AVURLAsset {
            resultUrls.append(urlAsset.url)
            groupHandler()
            
          } else {
            guard let exportSession = AVAssetExportSession(
              asset: asset,
              presetName: AVAssetExportPreset1920x1080
            ) else {
              return
            }
            let manager = FileManager.default
            let targetURL = manager.temporaryDirectory.appendingPathComponent("\(UUID().uuidString).mp4")
            
            exportSession.outputURL = targetURL
            exportSession.outputFileType = AVFileType.mp4
            exportSession.shouldOptimizeForNetworkUse = true
            
            exportSession.exportAsynchronously {
              DispatchQueue.main.async {
                guard exportSession.status == .completed else {
                  groupHandler()
                  return
                }
                
                let exportedAsset = AVURLAsset(url: targetURL)
                resultUrls.append(exportedAsset.url)
                groupHandler()
              }
            }
          }
        }
      }
      
      group.notify(queue: .main) {
        guard exportVideoRequests == 0 else {
          return
        }
        
        let presentingHandler = {
          guard !resultUrls.isEmpty else { return }
          completion(resultUrls[.zero])
        }
        
        presentingHandler()
      }
    }
  }
}
