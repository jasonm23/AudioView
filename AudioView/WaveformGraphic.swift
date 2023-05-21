import SwiftUI

struct WaveformGraphic: View {
    @Binding var lines: [Float]
    @Binding var steps: UInt
    @Binding var scaleHeight: Float
    @Binding var displayWidth: CGFloat

    private var lineWidth : CGFloat {
        get { displayWidth / CGFloat(steps) }
    }

    var reducedLines: [WaveformGraphicLineHeights] {
        lines.downSampled(steps: steps)
            .map { WaveformGraphicLineHeights(height: abs($0) * scaleHeight ) }
    }

    var body: some View {
        HStack {
            ForEach(reducedLines) { line in
                let height = line.height
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: lineWidth, height: CGFloat(height))
                    .foregroundColor(.systemTeal)

            }
        }.frame(width: 700)
    }
}

struct WaveformGraphicLineHeights: Identifiable {
    let id: UUID
    let height: Float

    init(height: Float) {
        self.id = UUID()
        self.height = height
    }
}
