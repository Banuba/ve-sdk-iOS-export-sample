[![](https://www.banuba.com/hubfs/Banuba_November2018/Images/Banuba%20SDK.png)](https://www.banuba.com/video-editor-sdk)

# iOS Banuba AI Video Editor Export API Integration Sample

This repository contains a sample of using AI Video Editor Export API in your mobile app.

Export API can apply configurable effects to video and export that video with specified parameters. Export API has no UI, hence cannot display applied effects.

It contains the must-have video editing features such as adding video effects, gif/text, watermark, speed effects, color effects, AR effects to the exported video with a predefined position, duration and period. It can also edit the aspect ratio.

- [Requirements](#Requirements)
- [Supported media formats](#Supported-media-formats)
- [Token](#Token)
- [Getting Started](#Getting-Started)
    + [CocoaPods](#CocoaPods)
    + [Configure edit flow](#Configure-edit-flow)
    + [Configure export flow](#Configure-export-flow)
    + [Configure watermark](#Configure-watermark)
    + [Configure effects](#Configure-effects)
- [API Reference](#API-Reference)
    + [Export API](#Export-API)
    + [Effects API](#Effects-API)
    + [Core API](#Core-API)

## Requirements
This is what you need to run the AI Video Editor SDK

- iPhone devices 6+
- Swift 5+
- Xcode 13+
- iOS 12.0+
Unfortunately, It isn't optimized for iPads.

## Supported media formats
| Audio      | Video      |
| ---------- | ---------  | 
| mp3, aac, wav, m4a, flac, aiff | mp4, mov, m4v |

## Export video quality params
You could customize it with `ExportVideoInfo`. Just put a required video quality into `ExportVideoInfo` constructor. To be able to use your own quality parametrs please follow this [line](https://github.com/Banuba/ve-sdk-iOS-export-sample/blob/b63c236ea1690ea8c460b103649dc1f3bc2c65f6/ExportAPISample/ExportAPISample/ViewControllerExtensions/ExportFunctionality%20.swift#L56).

See the **default bitrate (kbps)** for exported video (without audio) in the table below:
| 360p(360 x 640) | 480p(480 x 854) | 540p(540 x 960) | HD(720 x 1280) | FHD(1080 x 1920) |
| --------------- | --------------- | ---------------- | -------------- | ---------------- |
|              800|             2000|              2000|            4000|              6400|

## Starting a free trial

You should start with getting a trial token. It will grant you **14 days** to freely play around with the AI Video Editor SDK and test its entire functionality the way you see fit.

There is nothing complicated about it - [contact us](https://www.banuba.com/video-editor-sdk) or send an email to sales@banuba.com and we will send it to you. We can also send you a sample app so you can see how it works “under the hood”.

## Token 
We offer а free 14-days trial for you could thoroughly test and assess Video Editor SDK functionality in your app. To get access to your trial, please, get in touch with us by [filling a form](https://www.banuba.com/video-editor-sdk) on our website. Our sales managers will send you the trial token.

Video Editor token should be put [here](https://github.com/Banuba/ve-sdk-iOS-export-sample/blob/b63c236ea1690ea8c460b103649dc1f3bc2c65f6/ExportAPISample/ExportAPISample/ViewControllerExtensions/VideoEditorServiceInitialization.swift#L28).

## Getting Started
### CocoaPods

In the sample project there is a division into folders, such as 'sample' and 'helpers': all the functionality inherent in the API integration is in the ['sample'](https://github.com/Banuba/ve-sdk-iOS-export-sample/tree/master/ExportAPISample/ExportAPISample/Sample) folder, auxiliary information to support the functionality of the sample is in the ['helpers'](https://github.com/Banuba/ve-sdk-iOS-export-sample/tree/master/ExportAPISample/ExportAPISample/Helpers) folder.

The easiest way to integrate the Video Editor SDK in your mobile app is through [CocoaPods](https://cocoapods.org). If you haven’t used this dependency manager before, see the [Getting Started Guide](https://guides.cocoapods.org/using/getting-started.html).

Important: Make sure that you have CocoaPods version >= 1.9.0 installed. Check your CocoaPods version using this command [pod --version]

Please, refer to the example of [Podfile](https://github.com/Banuba/ve-sdk-iOS-export-sample/blob/master/ExportAPISample/Podfile) lines which you need to add.

1. Make sure to have CocoaPods installed, e.g. via Homebrew:
   ```sh
   brew install cocoapods 
   ```
2. Initialize pods in your project folder (if you didn't do it before).
   ```sh
   pod init
   ```
3. Install the Video Editor SDK for the provided Xcode workspace with:
```sh
pod install
```
4. Open Example.xcworkspace with Xcode and run the project.  

### Configure edit flow

Before exporting video you need to add your video asset to existing VideoEditorService instance.

``` swift
    // Add video to the sequence
    let videoSequence = VideoSequence(folderURL: folderURL)
    videoSequence.addVideo(at: videoFileURL)

    // Create VideoEditorAsset from relevant sequence
    let videoEditorAsset = VideoEditorAsset(
      sequence: videoSequence,
      isGalleryAssets: true,
      isSlideShow: false,
      videoResolutionConfiguration: videoResolutionConfiguration
    )
    
    // Set cuurent video asset to video editor service
    videoEditorService.setCurrentAsset(videoEditorAsset)
```
See the sample edit video flow [here](https://github.com/Banuba/ve-sdk-iOS-export-sample/blob/b63c236ea1690ea8c460b103649dc1f3bc2c65f6/ExportAPISample/ExportAPISample/ViewControllerExtensions/ExportFunctionality%20.swift#L25).

### Configure export flow

To export video after the editing is complete use these methods:

``` swift
/// Export video with input info and watermark model
  /// - Parameters:
  ///   - fileURL: destination file url.
  ///   - exportVideoInfo: Describes exporting video editor params.
  ///   - watermarkFilterModel: Watermark effect.
  ///   - completion: completion creation - (isSuccess,  error)
  func exportVideo(
    to fileURL: URL,
    using exportVideoInfo: ExportVideoInfo,
    watermarkFilterModel: VideoEditorFilterModel?,
    completion: ((_ isSuccess: Bool, _ error: Error?)-> Void)?
  )
```  

Before exporting you need to apply default rotate transform:
``` swift
    // Expected non-zero video aspect ratio constructor. Apply transform effect after adding required asset.
    // Apply temporary original rotation.
    let originalRotation: AssetRotation = .rotate90
    effectApplicator?.addTransformEffect(atStartTime: .zero, end: .indefinite, rotation: originalRotation)
```

See the sample export video flow [here](https://github.com/Banuba/ve-sdk-iOS-export-sample/blob/b63c236ea1690ea8c460b103649dc1f3bc2c65f6/ExportAPISample/ExportAPISample/ViewControllerExtensions/ExportFunctionality%20.swift#L62).

### Configure watermark

You can add a branded image that would appear on videos that users export. 

To do so, create and configure the WatermarkConfiguration structure, then add it to the ExportVideoConfiguration entity. 

See this [example](https://github.com/Banuba/ve-sdk-iOS-export-sample/blob/b63c236ea1690ea8c460b103649dc1f3bc2c65f6/ExportAPISample/ExportAPISample/ViewControllerExtensions/ExportFunctionality%20.swift#L65) for details.

### Configure effects

You can add an effect objects such as gif/text, viasual, speed, color to exporting video. 

To be able to use following functionality you need to operate on EffectApplicator entity.

Please, checkout [example](https://github.com/Banuba/ve-sdk-iOS-export-sample/blob/2eb9738c23b397caaf46bd665bf436107c863f6f/ExportAPISample/ExportAPISample/Sample/EffectsApplicator.swift#L15)

``` swift
/// EffectApplicator allows you to add GIF and text effects to your existing VideoEditorServiсe composition
public class EffectApplicator {
  /// EffectApplicator constructor
  /// - Parameters:
  ///   - editor: Instance of existing VideoEditorService
  ///   - editor: Instance of existing EditorEffectsConfigHolder
  init(
    editor: VideoEditorServicing,
    effectConfigHolder: EffectsHolderServicing
  )
  
  /// Allows you to add visual effects with required settings.
  /// - Parameters:
  ///   - type: Describes what kind of effect needs to be added
  ///   - startTime: When effect starts
  ///   - endTime: When effect ends
  ///   - removeSameType: Remove same effect if exist
  ///   - effectId: Unic effect id
  func applyVisualEffectApplicatorType(
    _ type: VisualEffectApplicatorType,
    startTime: CMTime,
    endTime: CMTime,
    removeSameType: Bool,
    effectId: UInt
  )
  
  /// Allows you to add speed effects with required settings.
  /// - Parameters:
  ///   - type: Describes what kind of effect needs to be added
  ///   - startTime: When effect starts
  ///   - endTime: When effect ends
  ///   - removeSameType: Remove same effect if exist
  ///   - effectId: Unic effect id
  func applySpeedEffectType(
    _ type: SpeedEffectType,
    startTime: CMTime,
    endTime: CMTime,
    removeSameType: Bool,
    effectId: UInt
  )
  
  /// Allows you to add GIF or text effects with required settings.
  /// - Parameters:
  ///   - type: Describes what kind of effect needs to be added
  ///   - effectInfo: Contains all the information you need to add effects to your video.
  func applyOverlayEffectType(
    _ type: OverlayEffectApplicatorType,
    effectInfo: VideoEditorEffectInfo
  )
  
  /// Allows you to add rotation effect with required settings.
  /// - Parameters:
  ///   - atStartTime: When effect is need to be start
  ///   - end: When effect is need to be end
  ///   - rotation: Video rotation settings
  func addTransformEffect(
    atStartTime start: CMTime,
    end: CMTime,
    rotation: AssetRotation
  )
}
```

## API Reference

Framework API's which implemented with export-sample.

### Export API

[API Reference](https://github.com/Banuba/VEExportSDK-iOS)

### Effects API

[API Reference](https://github.com/Banuba/BanubaVideoEditorEffectsSDK-iOS)


### Core API

[API Reference](https://github.com/Banuba/VideoEditor-iOS)
