import SwiftUI

extension Color {
    static var systemTeal: Color {
        let teal = NSColor.systemTeal
        return Color(teal)
    }
}

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

struct WaveFormGraphicContentView: View {
    @Binding var lines: [Float]?
    @Binding var duration: Double?

    var body: some View {
        GeometryReader { geometry in
            VStack {
                if let lines = lines {
                    WaveformGraphic(lines, steps: UInt(geometry.size.width / 3), lineWidth: 2)
                }
            }
        }
    }
}

struct WaveformGraphic: View {
    let lines: [Float]
    let steps: UInt
    let lineWidth: Int
    
    init(_ lines: [Float], steps: UInt = 100, lineWidth: Int = 6) {
        self.steps = steps
        self.lineWidth = lineWidth
        let scaled = lines.downSampled(steps: steps)
        self.lines = scaled.map { abs($0) }
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack{
                ForEach(lines, id: \.self) { line in
                    Rectangle()
                        .frame(width: CGFloat(lineWidth), height: CGFloat(line))
                        .cornerRadius(10)
                        .foregroundColor(.systemTeal)
                }
            }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            
        }
    }
}

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
