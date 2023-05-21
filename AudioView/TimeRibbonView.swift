import SwiftUI

struct TimeRibbonView: View {
    let duration: Double
    let interval: Double

    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<Int(duration / interval)) { index in
                let x = CGFloat(index) * geometry.size.width / CGFloat(duration / interval)
                Path { path in
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                }
                .stroke(Color(red: 0.3, green: 0.3, blue: 0.3, opacity: 0.6), lineWidth: 1)
            }
        }
    }
}
