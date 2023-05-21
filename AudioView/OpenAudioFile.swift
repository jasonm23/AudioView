//
//  OpenAudioFile.swift
//  AudioView
//
//  Created by jason on 11/4/23.
//

import SwiftUI

func openAudioFileDialog(allowed: [String] = ["m4a", "mp3", "wav", "aiff"]) -> (String?, [Float], Double?) {
    let dialog = NSOpenPanel()
    dialog.title = "Choose an audio file"
    dialog.allowedFileTypes = allowed
    
    if dialog.runModal() == .OK {
        if let audioFilePath = dialog.url?.path {
            let audioURL = URL(fileURLWithPath: audioFilePath)
            let windowSize = windowSize()
            
            // let (waveformImage, duration) = getWaveformImage(audioURL: audioURL,
            //                                                 size: windowSize)

            if let waveformMetadata = getWaveformSamples(audioURL: audioURL, size: windowSize) {
                let duration = waveformMetadata.duration
                let lines: [Float] =  waveformMetadata.samples.downSampled(width: 30, height: 150)
                return (audioFilePath, lines, duration)
            } else {
                return (nil, [], nil)
            }
        } else {
            return (nil, [], nil)
        }
    } else {
        return (nil, [], nil)
    }
}
