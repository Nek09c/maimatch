import SwiftUI

struct BackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                Image("maimaipixel")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.35)
            )
    }
}

extension View {
    func withDefaultBackground() -> some View {
        self.modifier(BackgroundModifier())
    }
} 