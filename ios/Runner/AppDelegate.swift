import AVFoundation
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    guard let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "HooplabReel") else {
      return
    }
    let channel = FlutterMethodChannel(
      name: "hooplab/reel",
      binaryMessenger: registrar.messenger()
    )
    channel.setMethodCallHandler { call, result in
      guard call.method == "encode",
            let args = call.arguments as? [String: Any],
            let dir = args["dir"] as? String,
            let output = args["output"] as? String
      else {
        result(false)
        return
      }
      let fps = args["fps"] as? Int ?? 10
      let width = args["width"] as? Int ?? 540
      let height = args["height"] as? Int ?? 960
      DispatchQueue.global(qos: .userInitiated).async {
        let ok = ReelEncoder.encode(
          dir: dir,
          fps: fps,
          width: width,
          height: height,
          output: output
        )
        DispatchQueue.main.async {
          result(ok)
        }
      }
    }
  }
}

enum ReelEncoder {
  static func encode(dir: String, fps: Int, width: Int, height: Int, output: String) -> Bool {
    let folder = URL(fileURLWithPath: dir)
    let files = ((try? FileManager.default.contentsOfDirectory(
      at: folder,
      includingPropertiesForKeys: nil
    )) ?? [])
      .filter { $0.pathExtension.lowercased() == "jpg" }
      .sorted { $0.lastPathComponent < $1.lastPathComponent }
    if files.isEmpty { return false }

    let outputURL = URL(fileURLWithPath: output)
    try? FileManager.default.removeItem(at: outputURL)
    guard let writer = try? AVAssetWriter(outputURL: outputURL, fileType: .mp4) else {
      return false
    }
    let settings: [String: Any] = [
      AVVideoCodecKey: AVVideoCodecType.h264,
      AVVideoWidthKey: width,
      AVVideoHeightKey: height,
      AVVideoCompressionPropertiesKey: [
        AVVideoAverageBitRateKey: 2_000_000,
        AVVideoProfileLevelKey: AVVideoProfileLevelH264BaselineAutoLevel,
      ],
    ]
    let input = AVAssetWriterInput(mediaType: .video, outputSettings: settings)
    input.expectsMediaDataInRealTime = false
    let attrs: [String: Any] = [
      kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
      kCVPixelBufferWidthKey as String: width,
      kCVPixelBufferHeightKey as String: height,
    ]
    let adaptor = AVAssetWriterInputPixelBufferAdaptor(
      assetWriterInput: input,
      sourcePixelBufferAttributes: attrs
    )
    guard writer.canAdd(input) else { return false }
    writer.add(input)
    guard writer.startWriting() else { return false }
    writer.startSession(atSourceTime: .zero)

    let scale = max(1, fps)
    for (index, file) in files.enumerated() {
      var waits = 0
      while !input.isReadyForMoreMediaData && waits < 200 {
        Thread.sleep(forTimeInterval: 0.01)
        waits += 1
      }
      if !input.isReadyForMoreMediaData { break }
      guard let image = UIImage(contentsOfFile: file.path),
            let buffer = pixelBuffer(from: image, width: width, height: height)
      else { continue }
      let time = CMTime(value: CMTimeValue(index), timescale: CMTimeScale(scale))
      if !adaptor.append(buffer, withPresentationTime: time) {
        break
      }
    }
    input.markAsFinished()
    let group = DispatchGroup()
    group.enter()
    writer.finishWriting {
      group.leave()
    }
    group.wait()
    return writer.status == .completed && FileManager.default.fileExists(atPath: output)
  }

  private static func pixelBuffer(from image: UIImage, width: Int, height: Int) -> CVPixelBuffer? {
    var buffer: CVPixelBuffer?
    let attrs: [String: Any] = [
      kCVPixelBufferCGImageCompatibilityKey as String: true,
      kCVPixelBufferCGBitmapContextCompatibilityKey as String: true,
    ]
    let status = CVPixelBufferCreate(
      kCFAllocatorDefault,
      width,
      height,
      kCVPixelFormatType_32BGRA,
      attrs as CFDictionary,
      &buffer
    )
    guard status == kCVReturnSuccess, let pixel = buffer else { return nil }
    CVPixelBufferLockBaseAddress(pixel, [])
    defer { CVPixelBufferUnlockBaseAddress(pixel, []) }
    guard let context = CGContext(
      data: CVPixelBufferGetBaseAddress(pixel),
      width: width,
      height: height,
      bitsPerComponent: 8,
      bytesPerRow: CVPixelBufferGetBytesPerRow(pixel),
      space: CGColorSpaceCreateDeviceRGB(),
      bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue
    ) else { return nil }
    context.setFillColor(UIColor.black.cgColor)
    context.fill(CGRect(x: 0, y: 0, width: width, height: height))
    if let cg = image.cgImage {
      context.draw(cg, in: CGRect(x: 0, y: 0, width: width, height: height))
    }
    return pixel
  }
}
