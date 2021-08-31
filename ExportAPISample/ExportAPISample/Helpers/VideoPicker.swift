//
//  VideoPicker.swift
//  HorizonSample
//
//  Created by Gleb Markin on 25.08.21.
//

import BSImagePicker
import Photos

class VideoPicker {
  func pickVideo(
    isMultipleSelectionEnabled: Bool = true,
    from controller: UIViewController,
    withCompletion completion: @escaping ([PHAsset]?) -> Void
  ) {
    let imagePicker = ImagePickerController()
    if !isMultipleSelectionEnabled {
      imagePicker.settings.selection.max = 1
    }
    imagePicker.settings.fetch.assets.supportedMediaTypes = [.video]
    
    controller.presentImagePicker(
      imagePicker,
      select: nil,
      deselect: nil,
      cancel: { assets in
        completion(nil)
      }, finish: { assets in
        completion(assets)
      }
    )
  }
}
