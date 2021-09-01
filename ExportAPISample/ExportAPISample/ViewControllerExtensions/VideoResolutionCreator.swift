//
//  VideoResolutionCreator.swift
//  ExportAPISample
//
//  Created by Gleb Markin on 1.09.21.
//

import Foundation

// Banuba Modules
import BanubaUtilities

// MARK: - VideoResolutionHelpers
extension ViewController {
  /// Create VideoResolutionConfiguration with required params.
  func prepareVideoResolutionConfiguration() -> VideoResolutionConfiguration {
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
