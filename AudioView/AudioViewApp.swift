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
    @State private var waveformWidth: CGFloat = 200.0

    @State private var lines: [Float] = []
    @State private var duration: Double?
    @State private var steps: UInt = 50
    @State private var scaleHeight: Float = 2.4
    @State private var lineWidth: Int = 8

    func updateSteps(_ change: Int) {
        if change > 0 {
            steps = min(UInt(Int(steps) + change), 200)
        } else {
            steps = UInt(max(0, Int(steps) + change))
        }
        lineWidth = min(Int(waveformWidth / CGFloat(steps)), 1)
    }

    var body: some Scene {
        WindowGroup {
            VStack {
                if let filePath = audioFilePath,
                   let title = filePath.split(separator: "/").last {

                    HStack {
                        Button(action: {
                            updateSteps(+1)
                        }) {
                            Text("More")
                        }
                        Text("\(steps)")
                        Button(action: {
                            updateSteps(-1)
                        }) {
                            Text("Less")
                        }
                    }.padding(10)
                    Text(title)
                        .padding(10)
                        .font(.title)
                    Spacer()
                    WaveformGraphic(lines: $lines,
                                    steps: $steps,
                                    scaleHeight: $scaleHeight,
                                    displayWidth: $waveformWidth)
                        .frame(height: 300)
                    Spacer()
                } else {
                    Spacer()
                }
            }.frame(minWidth: 500, idealWidth: 800, maxWidth: 1920,
                    minHeight: 450, idealHeight: 600, maxHeight: 1080,
                    alignment: .center)
        }.commands {
            CommandGroup(replacing: .newItem) {
                Button("Open Audio File") {
                    if let waveformMetadata : WaveformMetadata = openAudioFileDialog() {
                        lines = waveformMetadata.samples
                        audioFilePath = waveformMetadata.url.path
                        duration = waveformMetadata.duration
                    }
                }.keyboardShortcut("o")
            }
        }
    }
}
