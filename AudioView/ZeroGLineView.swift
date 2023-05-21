import SwiftUI

struct ZeroGLineView: View {
    let height: CGFloat

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: 0, y: height/2))
                path.addLine(to: CGPoint(x: geometry.size.width, y: height/2))
            }
            .stroke(Color(red: 0.6, green: 0, blue: 0, opacity: 0.5), lineWidth: 1)
        }
    }
}
