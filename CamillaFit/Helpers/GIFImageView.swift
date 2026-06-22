import SwiftUI
import UIKit
import ImageIO

struct GIFImageView: UIViewRepresentable {
    let gifName: String
    let sfSymbolFallback: String

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        loadGIF(into: imageView)
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {}

    private func loadGIF(into imageView: UIImageView) {
        // Try loading from bundle
        if let url = Bundle.main.url(forResource: gifName, withExtension: "gif"),
           let data = try? Data(contentsOf: url) {
            imageView.image = UIImage.animatedImage(fromGIFData: data)
            return
        }

        // Try asset catalog
        if let asset = NSDataAsset(name: gifName) {
            imageView.image = UIImage.animatedImage(fromGIFData: asset.data)
            return
        }

        // Fallback: SF Symbol
        let config = UIImage.SymbolConfiguration(pointSize: 80, weight: .light)
        let symbol = UIImage(systemName: sfSymbolFallback, withConfiguration: config)
        imageView.image = symbol
        imageView.tintColor = .white
        imageView.contentMode = .center
    }
}

// MARK: - GIF Decoding

extension UIImage {
    static func animatedImage(fromGIFData data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }

        let count = CGImageSourceGetCount(source)
        var images: [UIImage] = []
        var totalDuration: Double = 0

        for i in 0..<count {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) else { continue }
            images.append(UIImage(cgImage: cgImage))

            let frameDuration = GIFHelpers.frameDuration(at: i, source: source)
            totalDuration += frameDuration
        }

        guard !images.isEmpty else { return nil }
        return UIImage.animatedImage(with: images, duration: totalDuration)
    }
}

private enum GIFHelpers {
    static func frameDuration(at index: Int, source: CGImageSource) -> Double {
        let defaultDuration = 0.1

        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [CFString: Any],
              let gifProperties = properties[kCGImagePropertyGIFDictionary] as? [CFString: Any] else {
            return defaultDuration
        }

        if let unclamped = gifProperties[kCGImagePropertyGIFUnclampedDelayTime] as? Double, unclamped > 0 {
            return unclamped
        }
        if let delay = gifProperties[kCGImagePropertyGIFDelayTime] as? Double, delay > 0 {
            return delay
        }
        return defaultDuration
    }
}
