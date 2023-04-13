//
//  OpenAudioFile.swift
//  AudioView
//
//  Created by jason on 11/4/23.
//

import SwiftUI

func openAudioFileDialog(allowed: [String] = ["m4a", "mp3", "wav", "aiff"]) -> (String?, NSImage?, Double?) {
    let dialog = NSOpenPanel()
    dialog.title = "Choose an audio file"
    dialog.allowedFileTypes = allowed
    
    if dialog.runModal() == .OK {
        if let audioFilePath = dialog.url?.path {
            let audioURL = URL(fileURLWithPath: audioFilePath)
            let windowSize = windowSize()
            
            let (waveformImage, duration) = getWaveformImage(audioURL: audioURL,
                                                             size: windowSize)
            
            return (audioFilePath, waveformImage, duration)
        } else {
            return (nil, nil, nil)
        }
    } else {
        return (nil, nil, nil)
    }
}
