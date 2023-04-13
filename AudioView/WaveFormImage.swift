//
//  WaveFormImage.swift
//  AudioView
//
//  Created by jason on 11/4/23.
//

import SwiftUI
import AVFoundation
import Accelerate

extension Array where Element == Float {
    func downSampled(size: CGSize, scaleFactor: Int = 2) -> [Float] {
        return self.downSampled(width: Int(size.width), height: Int(size.height), scaleFactor: scaleFactor)
    }
    
    func downSampled(width: Int, height: Int, scaleFactor: Int = 2) -> [Float] {
        let count = self.count
        let resampleCount = Swift.max((count / 10), width)
        if count > resampleCount {

            let numSamplesPerPixel = count > resampleCount ? count / resampleCount : count
            
            var filter = [Float](repeating: 1.0 / Float(numSamplesPerPixel),
                                 count: Int(numSamplesPerPixel))
            
            var downSampledData = [Float](repeating:0.0, count: resampleCount)
            
            vDSP_desamp(self,
                        vDSP_Stride(numSamplesPerPixel),
                        &filter,
                        &downSampledData,
                        vDSP_Length(resampleCount),
                        vDSP_Length(numSamplesPerPixel))
            
            var maxVal: Float = 0.0
            vDSP_maxv(downSampledData,
                      1,
                      &maxVal,
                      vDSP_Length(resampleCount))

            let scale = maxVal > 0.0 ? Float(height / scaleFactor) / maxVal : 1.0
            
            vDSP_vsmul(downSampledData,
                       1,
                       [scale],
                       &downSampledData,
                       1,
                       vDSP_Length(resampleCount))
            
            return downSampledData
        } else {
            var maxVal: Float = 0.0
            
            var samples = self
            
            vDSP_maxv(samples,
                      1,
                      &maxVal,
                      vDSP_Length(samples.count))
            
            let scale = maxVal > 0.0 ? Float(height / scaleFactor) / maxVal : 1.0
            
            vDSP_vsmul(samples,
                       1,
                       [scale],
                       &samples,
                       1,
                       vDSP_Length(samples.count))
            
            return samples
        }
    }
}

func getWaveformImage(audioURL: URL, size: CGSize, range: ClosedRange<Int>? = nil) -> (NSImage?, Double?) {
    
    // Create an AVAudioFile object with the specified URL
    guard let audioFile = try? AVAudioFile(forReading: audioURL) else {
        print("Unable to read \(audioURL.path)")
        return (nil, nil)
    }
    
    // Get the format of the audio file (e.g. sample rate, number of channels)
    let format = audioFile.processingFormat
    
    // Get the total number of frames in the audio file
    let frameCount = AVAudioFrameCount(audioFile.length)
    
    // Create an AVAudioPCMBuffer to hold the audio data
    let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)!
    
    // Read the audio data from the file into the buffer
    do {
        try audioFile.read(into: buffer)
    } catch {
        print("Unable to read \(audioURL.path) info buffer")
        return (nil, nil)
    }
    
    // Get the float array of samples from the buffer
    let rawSamples = Array(UnsafeBufferPointer(start: buffer.floatChannelData![0], count: Int(buffer.frameLength)))
    var selectedSamples = rawSamples
    
    
    // Select range.
    if let range = range {
        selectedSamples = Array(rawSamples[range])
    }
    
    let samples = selectedSamples
        .downSampled(size: size, scaleFactor: 6)
    
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
    
    let duration = Double(samples.count) / format.sampleRate
    
    // Create image
    let image = NSImage(size: size)
    image.lockFocus()
    NSColor.systemTeal.setStroke()
    path.stroke()
    image.unlockFocus()
    
    return (image, duration)
}
