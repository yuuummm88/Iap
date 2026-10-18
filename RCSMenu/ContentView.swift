import SwiftUI

struct ContentView: View {
    private let horizontalPadding: CGFloat = 12
    private let verticalPadding: CGFloat = 12
    private let headerHeight: CGFloat = 50

    @State private var isMenuVisible = true
    @State private var panelCenter: CGPoint?
    @GestureState private var dragTranslation = CGSize.zero

    var body: some View {
        GeometryReader { proxy in
            let metrics = OverlayMetrics(proxy: proxy, horizontalPadding: horizontalPadding,
                                         verticalPadding: verticalPadding, headerHeight: headerHeight)
            ZStack {
                MockGameBackground()
                if isMenuVisible {
                    menu(metrics: metrics)
                        .position(metrics.clamped(translatedCenter(for: metrics)))
                        .onAppear { resetCenterIfNeeded(for: metrics) }
                        .onChange(of: proxy.size) { _ in panelCenter = metrics.clamped(panelCenter ?? metrics.defaultCenter) }
                        .onChange(of: proxy.safeAreaInsets) { _ in panelCenter = metrics.clamped(panelCenter ?? metrics.defaultCenter) }
                } else {
                    reopenButton(metrics: metrics)
                }
            }
            .ignoresSafeArea()
        }
    }

    private func menu(metrics: OverlayMetrics) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Text("RCS MENU")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white)
                Spacer(minLength: 0)
                Button("HIDE") { isMenuVisible = false }
                    .font(.caption.weight(.bold))
                    .buttonStyle(.bordered)
                    .tint(.cyan)
                    .accessibilityLabel("Hide RCS Menu settings")
            }
            .padding(.horizontal, 12)
            .frame(height: headerHeight)
            .background(Color(red: 9 / 255, green: 13 / 255, blue: 23 / 255))
            .contentShape(Rectangle())
            .gesture(dragGesture(metrics: metrics))

            MenuWebView()
                .frame(height: metrics.webHeight)
        }
        .frame(width: metrics.panelSize.width, height: metrics.panelSize.height)
        .background(Color(red: 9 / 255, green: 13 / 255, blue: 23 / 255))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(Color.cyan, lineWidth: 2))
        .shadow(color: .black.opacity(0.35), radius: 10, y: 4)
        .accessibilityElement(children: .contain)
    }

    private func reopenButton(metrics: OverlayMetrics) -> some View {
        Button { isMenuVisible = true } label: {
            Text("RCS")
                .font(.caption.weight(.heavy))
                .foregroundStyle(.white)
                .frame(width: 52, height: 52)
                .background(Color(red: 9 / 255, green: 13 / 255, blue: 23 / 255))
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.cyan, lineWidth: 2))
        }
        .buttonStyle(.plain)
        .position(metrics.reopenCenter)
        .accessibilityLabel("Show RCS Menu settings")
    }

    private func dragGesture(metrics: OverlayMetrics) -> some Gesture {
        DragGesture(minimumDistance: 4)
            .updating($dragTranslation) { value, state, _ in state = value.translation }
            .onEnded { value in
                panelCenter = metrics.clamped(CGPoint(x: (panelCenter ?? metrics.defaultCenter).x + value.translation.width,
                                                       y: (panelCenter ?? metrics.defaultCenter).y + value.translation.height))
            }
    }

    private func translatedCenter(for metrics: OverlayMetrics) -> CGPoint {
        let center = panelCenter ?? metrics.defaultCenter
        return CGPoint(x: center.x + dragTranslation.width, y: center.y + dragTranslation.height)
    }

    private func resetCenterIfNeeded(for metrics: OverlayMetrics) {
        if panelCenter == nil { panelCenter = metrics.defaultCenter }
    }
}

private struct OverlayMetrics {
    let panelSize: CGSize
    let bounds: CGRect
    let headerHeight: CGFloat

    init(proxy: GeometryProxy, horizontalPadding: CGFloat, verticalPadding: CGFloat, headerHeight: CGFloat) {
        let safe = proxy.safeAreaInsets
        let usableWidth = max(0, proxy.size.width - safe.leading - safe.trailing)
        let usableHeight = max(0, proxy.size.height - safe.top - safe.bottom)
        panelSize = CGSize(width: usableWidth * 0.80, height: usableHeight * 0.70)
        bounds = CGRect(x: safe.leading + horizontalPadding, y: safe.top + verticalPadding,
                        width: max(0, usableWidth - horizontalPadding * 2),
                        height: max(0, usableHeight - verticalPadding * 2))
        self.headerHeight = headerHeight
    }

    var webHeight: CGFloat { max(0, panelSize.height - headerHeight) }
    var defaultCenter: CGPoint { CGPoint(x: bounds.midX, y: bounds.midY) }
    var reopenCenter: CGPoint { CGPoint(x: bounds.maxX - 26, y: bounds.minY + 26) }

    func clamped(_ center: CGPoint) -> CGPoint {
        let halfWidth = panelSize.width / 2
        let halfHeight = panelSize.height / 2
        return CGPoint(x: min(max(center.x, bounds.minX + halfWidth), bounds.maxX - halfWidth),
                       y: min(max(center.y, bounds.minY + halfHeight), bounds.maxY - halfHeight))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View { ContentView() }
}
