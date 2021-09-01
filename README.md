[![](https://www.banuba.com/hubfs/Banuba_November2018/Images/Banuba%20SDK.png)](https://www.banuba.com/video-editor-sdk)

# Video Editor SDK. Export Integration sample for iOS.

- [Requirements](#Requirements)
- [Supported media formats](#Supported-media-formats)
- [Token](#Token)
- [Getting Started](#Getting-Started)
    + [CocoaPods](#CocoaPods)
    + [Configure edit flow](#Configure-edit-flow)
    + [Configure export flow](#Configure-export-flow)
    + [Configure watermark](#Configure-watermark)
    + [Configure overlay effects](#Configure-overlay-effect)

## Requirements
This is what you need to run the AI Video Editor SDK

- iPhone devices 6+
- Swift 5+
- Xcode 12.4+
- iOS 11.0+
Unfortunately, It isn't optimized for iPads.

## Supported media formats
| Audio      | Video      | Images      |
| ---------- | ---------  | ----------- |
|.mp3, .aac, .wav, <br>.m4a, .flac, .aiff |.mp4, .mov, .m4v| .bmp, .gif, .heic, <br>.jpeg, .jpg, .png, .tiff 

## Export video quality params
Video Editor SDK classifies every device by its performance capabilities and uses the most suitable quality params for the exported video.

Nevertheless it is possible to customize it with `ExportVideoInfo`. Just put a required video quality into `ExportVideoInfo` constructor. To be able to use your own quality parametrs please follow this [line](https://github.com/Banuba/ve-sdk-iOS-export-sample/blob/c155a5b49c7c27be7efb6e8991de8c59c7e7943d/ExportAPISample/ExportAPISample/ViewController.swift#L95).

See the **default bitrate (kbps)** for exported video (without audio) in the table below:
| 360p(360 x 640) | 480p(480 x 854) | 540p(540 x 960) | HD(720 x 1280) | FHD(1080 x 1920) |
| --------------- | --------------- | ---------------- | -------------- | ---------------- |
|              800|             2000|              2000|            4000|              6400|

## Starting a free trial

You should start with getting a trial token. It will grant you **14 days** to freely play around with the AI Video Editor SDK and test its entire functionality the way you see fit.

There is nothing complicated about it - [contact us](https://www.banuba.com/video-editor-sdk) or send an email to sales@banuba.com and we will send it to you. We can also send you a sample app so you can see how it works “under the hood”.

## Token 
We offer а free 14-days trial for you could thoroughly test and assess Video Editor SDK functionality in your app. To get access to your trial, please, get in touch with us by [filling a form](https://www.banuba.com/video-editor-sdk) on our website. Our sales managers will send you the trial token.

Video Editor token should be put [here](https://github.com/Banuba/ve-sdk-iOS-export-sample/blob/c155a5b49c7c27be7efb6e8991de8c59c7e7943d/ExportAPISample/ExportAPISample/ViewController.swift#L50).

## Getting Started
### CocoaPods

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
See the sample edit video flow [here](https://github.com/Banuba/ve-sdk-iOS-export-sample/blob/c155a5b49c7c27be7efb6e8991de8c59c7e7943d/ExportAPISample/ExportAPISample/ViewController.swift#L67).

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
  
  /// Export clean video without applied effects with input info and watermark model.
  /// - Parameters:
  ///   - fileURL: destination file url.
  ///   - mediaInfo: Describes exporting video editor params.
  ///   - completion: completion creation - (isSuccess,  error)
  public func exportCleanVideo(
    to file: URL,
    mediaInfo: ExportVideoInfo,
    completion: ((_ isSuccess: Bool, _ error: Error?) -> Void)?
  )
```  

Before exporting you need to apply default rotate transform:
``` swift
    // Expected non-zero video aspect ratio constructor. Apply transform effect after adding required asset.
    let transformApplicator = TransformEffectApplicator(editor: videoEditorService)
    transformApplicator.addTransformEffect(atStartTime: .zero, end: .indefinite, rotation: .rotate90)
```

See the sample export video flow [here](https://github.com/Banuba/ve-sdk-iOS-export-sample/blob/c155a5b49c7c27be7efb6e8991de8c59c7e7943d/ExportAPISample/ExportAPISample/ViewController.swift#L101).

### Configure watermark

You can add a branded image that would appear on videos that users export. 

To do so, create and configure the WatermarkConfiguration structure, then add it to the ExportVideoConfiguration entity. 

See this [example](https://github.com/Banuba/ve-sdk-iOS-export-sample/blob/c155a5b49c7c27be7efb6e8991de8c59c7e7943d/ExportAPISample/ExportAPISample/ViewController.swift#L104) for details.

### Configure overlay effects

You can add an overlay effect objects such as gif and text to exporting video. 

To be able to use following functionality you need to operate on EffectApplicator entity and VideoEditorEffectInfo params.

Please, checkout [example](https://github.com/Banuba/ve-sdk-iOS-export-sample/blob/c155a5b49c7c27be7efb6e8991de8c59c7e7943d/ExportAPISample/ExportAPISample/ViewController.swift#L118)

``` swift
/// EffectApplicator allows you to add GIF and text effects to your existing VideoEditorServiсe composition
public class EffectApplicator {
  /// VideoEditorService instance
  private let editor: VideoEditorServicing
  
  /// EffectApplicator constructor
  /// - Parameters:
  ///   - editor: Instance of existing VideoEditorService
  public init(
    editor: VideoEditorServicing
  )
  
  /// Allows you to add GIF or text effects with required settings.
  /// - Parameters:
  ///   - type: Describes what kind of effect needs to be added
  ///   - effectInfo: Contains all the information you need to add effects to your video.
  public func applyEffectType(
    _ type: EffectApplicatorType,
    effectInfo: VideoEditorEffectInfo
  )
}

/// VideoEditorEffectInfo contains all the information you need to add effects to your video.
public struct VideoEditorEffectInfo {
  /// Effect id
  public private(set) var id: UInt
  /// Effect snapshot
  public private(set) var image: UIImage
  /// Describes the relative screen points of the effects on the screen
  public private(set) var relativeScreenPoints: ImagePoints
  /// When effect starts
  public private(set) var start: CMTime
  /// When effect ends
  public private(set) var end: CMTime
  
  /// VideoEditorEffectInfo constructor
  /// - Parameters:
  ///   - id: Effect id
  ///   - image: Effect snapshot
  ///   - relativeScreenPoints: Describes the relative screen points of the effects on the screen
  ///   - start: When effect starts
  ///   - end: When effect ends
  public init(
    id: UInt,
    image: UIImage,
    relativeScreenPoints: ImagePoints,
    start: CMTime,
    end: CMTime
  )
}
```
