import SwiftUI

struct ContentView: View {
    @State private var isMenuVisible = true
    @State private var panelOffset = CGSize(width: 0, height: 80)
    @GestureState private var dragTranslation = CGSize.zero

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topTrailing) {
                MockGameBackground()

                if isMenuVisible {
                    VStack(spacing: 8) {
                        HStack {
                            Text("DEMO SETTINGS")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.white)
                            Spacer()
                            Button("HIDE") { isMenuVisible = false }
                                .font(.caption.weight(.bold))
                                .buttonStyle(.bordered)
                                .tint(.cyan)
                                .accessibilityLabel("Hide RCS Menu settings")
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(red: 9/255, green: 13/255, blue: 23/255))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        MenuWebView()
                            .frame(width: min(390, proxy.size.width - 32), height: min(640, proxy.size.height * 0.70))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .frame(width: min(390, proxy.size.width - 32))
                    .offset(x: panelOffset.width + dragTranslation.width,
                            y: panelOffset.height + dragTranslation.height)
                    .gesture(
                        DragGesture()
                            .updating($dragTranslation) { value, state, _ in state = value.translation }
                            .onEnded { value in
                                let proposed = CGSize(width: panelOffset.width + value.translation.width,
                                                      height: panelOffset.height + value.translation.height)
                                panelOffset = clamped(proposed, in: proxy.size)
                            }
                    )
                    .accessibilityElement(children: .contain)
                } else {
                    Button {
                        isMenuVisible = true
                    } label: {
                        Label("Show Menu", systemImage: "slider.horizontal.3")
                            .font(.headline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.cyan)
                    .padding()
                    .accessibilityLabel("Show RCS Menu settings")
                }
            }
        }
    }

    private func clamped(_ proposed: CGSize, in size: CGSize) -> CGSize {
        // Keep the drag origin comfortably on screen. The panel itself remains scrollable.
        CGSize(width: min(max(proposed.width, -size.width * 0.30), size.width * 0.30),
               height: min(max(proposed.height, -size.height * 0.30), size.height * 0.30))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
