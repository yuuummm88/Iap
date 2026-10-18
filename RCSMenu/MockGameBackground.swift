import SwiftUI

/// Visual-only test scene for the standalone menu. It has no game integration.
struct MockGameBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.05, green: 0.12, blue: 0.22), Color(red: 0.10, green: 0.28, blue: 0.33)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                Rectangle()
                    .fill(Color(red: 0.08, green: 0.16, blue: 0.15))
                    .frame(height: 180)
                    .overlay(alignment: .top) {
                        HStack(spacing: 44) {
                            skyline(height: 74)
                            skyline(height: 116)
                            skyline(height: 88)
                            skyline(height: 132)
                        }
                        .frame(maxWidth: .infinity, alignment: .bottom)
                    }
            }

            VStack {
                HStack {
                    Label("MOCK TRAINING ARENA", systemImage: "gamecontroller")
                        .font(.caption.weight(.bold))
                        .padding(10)
                        .background(.black.opacity(0.35), in: Capsule())
                    Spacer()
                    Text("DEMO")
                        .font(.caption.weight(.bold))
                        .padding(10)
                        .background(.cyan.opacity(0.75), in: Capsule())
                }
                .padding()
                Spacer()
                Image(systemName: "scope")
                    .font(.system(size: 120, weight: .thin))
                    .foregroundStyle(.white.opacity(0.30))
                Spacer()
            }
            .foregroundStyle(.white)
        }
        .accessibilityLabel("Mock game background for menu demonstration")
    }

    private func skyline(height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color(red: 0.04, green: 0.09, blue: 0.13))
            .frame(width: 42, height: height)
    }
}
