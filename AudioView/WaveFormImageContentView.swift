import SwiftUI

struct WaveFormImageContentView: View {
    @Binding var waveformImage: NSImage?
    @Binding var duration: Double?

    var body: some View {
        GeometryReader { geometry in
            VStack {
               ZStack {
                   if let duration = duration {
                       WaveformImageView(waveformImage: $waveformImage)
                       ZeroGLineView(height: geometry.size.height)
                       TimeRibbonView(duration: duration, interval: 1)
                   }
               }
            }
        }
    }
}
