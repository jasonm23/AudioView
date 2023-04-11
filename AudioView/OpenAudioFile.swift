//
//  OpenAudioFile.swift
//  AudioView
//
//  Created by jason on 11/4/23.
//

import SwiftUI

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
