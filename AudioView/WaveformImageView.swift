import SwiftUI

struct WaveformImageView: View {
    @Binding var waveformImage: NSImage?
    var body: some View {
        if let waveformImage = waveformImage {
            Image(nsImage: waveformImage)
                .resizable()
                .aspectRatio(contentMode: ContentMode.fill)
        }
    }
}
