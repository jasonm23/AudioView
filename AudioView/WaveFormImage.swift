//
//  WaveFormImage.swift
//  AudioView
//
//  Created by jason on 11/4/23.
//

import SwiftUI
import AVFoundation

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
