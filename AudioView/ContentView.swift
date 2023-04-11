import SwiftUI
import AVFoundation

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

func windowSize() -> CGSize {
    return NSApplication.shared.windows
        .first?.contentView?
        .frame.size ?? CGSize(width: 400, height: 200)
}

func openAudioFileDialog() -> (String?, NSImage?) {
    let dialog = NSOpenPanel()
    dialog.title = "Choose an audio file"
    dialog.allowedFileTypes = ["m4a", "mp3", "wav", "aiff"]
    
    if dialog.runModal() == .OK {
        if let audioFilePath = dialog.url?.path {
            let audioURL = URL(fileURLWithPath: audioFilePath)
            let windowSize = windowSize()
            let waveformImage = getWaveformImage(audioURL: audioURL, size: windowSize)
            return (audioFilePath, waveformImage)
        } else {
            return (nil, nil)
        }
    } else {
        return (nil,nil)
    }
}

func getWaveformImage(audioURL: URL, size: CGSize) -> NSImage? {
    guard let audioFile = try? AVAudioFile(forReading: audioURL),
          let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: AVAudioFrameCount(audioFile.length)) else {
              return nil
          }
    
    try? audioFile.read(into: audioBuffer)
    
    let rawSamples = Array(UnsafeBufferPointer(start: audioBuffer.floatChannelData?[0], count: Int(audioBuffer.frameLength)))
    
    // Scale samples to fit in the image height
    let maxSampleValue = rawSamples.max() ?? 0
    let scaleFactor = maxSampleValue != 0 ? Float(size.height / 6) / maxSampleValue : 0
    let samples = rawSamples.map { $0 * scaleFactor }
    
    // Create path
    let path = NSBezierPath()
    
    let xStep = size.width / CGFloat(samples.count - 1)
    var x: CGFloat = 0
    var y = size.height / 2
    
    path.move(to: CGPoint(x: x, y: y))
    for sample in samples {
        x += xStep
        y = size.height / 2 + CGFloat(sample)
        path.line(to: CGPoint(x: x, y: y))
    }
    
    // Create image
    let image = NSImage(size: size)
    image.lockFocus()
    NSColor.systemTeal.setStroke()
    path.stroke()
    image.unlockFocus()
    
    return image
}
