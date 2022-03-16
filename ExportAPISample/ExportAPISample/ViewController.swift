//
//  ViewController.swift
//  ExportAPISample
//
//  Created by Gleb Markin on 31.08.21.
//

import UIKit

// Banuba Modules
import VideoEditor
import VEEffectsSDK

class ViewController: UIViewController {
  
  // MARK: - Video editor service instance
  var videoEditorService: VideoEditorService?
  
  // MARK: - EffectApplicator instance
  var effectApplicator: EffectApplicator?

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
