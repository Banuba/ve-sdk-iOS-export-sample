//
//  GalleryManager.swift
//  ExportAPISample
//
//  Created by Gleb Markin on 1.09.21.
//

import Foundation
import Photos

// MARK: - BSImagePicker gallery helper
extension ViewController {
  /// Allows you to open gallery and get choosen asset via completion. Video picker entity based on third party library BSImagePicker.
  func openGallery(completion: @escaping (URL) -> Void) {
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
