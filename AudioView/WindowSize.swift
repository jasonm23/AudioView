//
//  WindowSize.swift
//  AudioView
//
//  Created by jason on 11/4/23.
//

import SwiftUI

func windowSize() -> CGSize {
    return NSApplication.shared.windows
        .first?.contentView?
        .frame.size ?? CGSize(width: 400, height: 200)
}
