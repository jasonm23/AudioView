//
//  OpenAudioFile.swift
//  AudioView
//
//  Created by jason on 11/4/23.
//

import SwiftUI

func openAudioFileDialog(allowed: [String] = ["m4a", "mp3", "wav", "aiff"]) -> WaveformMetadata? {
    let dialog = NSOpenPanel()
    dialog.title = "Choose an audio file"
    dialog.allowedFileTypes = allowed

    if dialog.runModal() == .OK {
        if let audioFilePath = dialog.url?.path {
            let audioURL = URL(fileURLWithPath: audioFilePath)
            let windowSize = windowSize()

            if let waveformMetadata = getWaveformSamples(audioURL: audioURL, size: windowSize) {
                return waveformMetadata
            }
        }
    }

    return nil
}
