import SwiftUI

struct ContentView: View {
    @Binding var waveformImage: NSImage?
    @Binding var duration: Double?
   
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    if let waveformImage = waveformImage,
                       let duration = duration {
                        Image(nsImage: waveformImage)
                            .resizable()
                            .aspectRatio(contentMode: ContentMode.fill)
                        ZeroGLineView(height: geometry.size.height)
                        TimeRibbonView(duration: duration, interval: 1)
                    }
                }
            }
        }
    }
}

struct TimeRibbonView: View {
    let duration: Double
    let interval: Double
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<Int(duration / interval)) { index in
                let x = CGFloat(index) * geometry.size.width / CGFloat(duration / interval)
                Path { path in
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                }
                .stroke(Color(red: 0.3, green: 0.3, blue: 0.3, opacity: 0.6), lineWidth: 1)
            }
        }
    }
}

struct ZeroGLineView: View {
    let height: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: 0, y: height/2))
                path.addLine(to: CGPoint(x: geometry.size.width, y: height/2))
            }
            .stroke(Color(red: 0.6, green: 0, blue: 0, opacity: 0.5), lineWidth: 1)
        }
    }
}
