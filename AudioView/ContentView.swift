import SwiftUI

struct ContentView: View {
    @Binding var waveformImage: NSImage?
    
    var body: some View {
        VStack {
            if let waveformImage = waveformImage {
                Image(nsImage: waveformImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .padding()
    }
}
