//
//  AudioViewApp.swift
//  AudioView
//
//  Created by jason on 10/4/23.
//

import SwiftUI

@main
struct AudioViewApp: App {
    
    @State private var audioFilePath: String?
    @State private var waveformImage: NSImage?
    
    var body: some Scene {
        WindowGroup {
            ContentView(waveformImage: $waveformImage)
                .frame(minWidth: 800, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
        }.commands {
            CommandGroup(replacing: .newItem) {
                Button("Open Audio File") {
                    (audioFilePath, waveformImage) = openAudioFileDialog()
                }
            }
        }
    }
}

