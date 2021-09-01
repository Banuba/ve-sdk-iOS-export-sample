//
//  ActivityViewControllerAssistant.swift
//  ExportAPISample
//
//  Created by Gleb Markin on 1.09.21.
//

import Foundation
import UIKit

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
