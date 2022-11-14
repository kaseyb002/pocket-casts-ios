import SwiftUI

struct PlusLandingView: View {
    @ObservedObject var coordinator: PlusCoordinator

    var body: some View {
        ZStack {
            PlusBackgroundGradientView()

            ScrollViewIfNeeded {
                VStack(alignment: .leading) {
                    HStack(alignment: .top, spacing: 12) {
                        Image("plus-pc-icon-white")
                        Image("plus-icon-white")
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        PlusLabel("Everything you love about Pocket Casts, plus more", for: .title)
                        PlusLabel("Get access to exclusive features and customisation options", for: .subtitle)
                    }.padding(.top, 24)

                    // Plus Features - Center between the text and the buttons
                    Spacer()
                    HorizontalScrollView {
                        ForEach(features) { model in
                            CardView(model: model, isLast: (model == features.last))
                        }
                    }.padding(ViewConfig.padding.features)
                    Spacer()

                    // Buttons
                    VStack(alignment: .leading, spacing: 16) {
                        Button("Unlock All Features") {
                            coordinator.unlockTapped()
                        }.buttonStyle(PlusGradientFilledButtonStyle(isLoading: coordinator.isLoadingPrices))

                        Button("Not Now") {
                            coordinator.dismissTapped()
                        }.buttonStyle(PlusGradientStrokeButton())
                    }
                }.padding(ViewConfig.padding.view)
                    .padding(.bottom)
            }
        }.enableProportionalValueScaling().ignoresSafeArea()
    }

    // Static list of the feature models to display
    private let features = [
        PlusFeature(iconName: "plus-feature-desktop",
                    title: "Desktop Apps",
                    description: "Listen in more places with our Windows, macOS and Web apps"),
        PlusFeature(iconName: "plus-feature-folders",
                    title: "Folders",
                    description: "Organise your podcasts in folders, and keep them in sync across all your devices"),
        PlusFeature(iconName: "plus-feature-cloud",
                    title: "10GB Cloud Storage",
                    description: "Upload your files to cloud storage and have it available everywhere"),
        PlusFeature(iconName: "plus-feature-watch",
                    title: "Watch Playback",
                    description: "Ditch the phone and go for a run - without missing a beat. Apple Watch stands alone"),
        PlusFeature(iconName: "plus-feature-hide-ads",
                    title: "Hide Ads",
                    description: "Ad-free experience which gives you more of what you love and less of what you don’t"),
        PlusFeature(iconName: "plus-feature-themes",
                    title: "Themes & Icons",
                    description: "Fly your true colours. Exclusive icons and themes for the plus club only")
    ]
}

// MARK: - Config
private extension Color {
    static let backgroundColor = Color(hex: "121212")
    static let leftCircleColor = Color(hex: "ffb626")
    static let rightCircleColor = Color(hex: "ffd845")
    static let textColor = Color.white

    // Feature Cards
    static let cardGradient = LinearGradient(colors: [Color(hex: "2A2A2B"), Color(hex: "252525")],
                                             startPoint: .top, endPoint: .bottom)
    static let cardStroke = Color(hex: "383839")
}

private enum ViewConfig {
    struct padding {
        static let horizontal = 20.0

        static let view = EdgeInsets(top: 70,
                                     leading: Self.horizontal,
                                     bottom: 20,
                                     trailing: Self.horizontal)

        // This resets the total view padding to allow the scrollview to go fully to the edges
        static let features = EdgeInsets(top: 36,
                                         leading: -Self.horizontal,
                                         bottom: 36,
                                         trailing: -Self.horizontal)

        static let featureCardMargin: Double = 15.0
    }

    static let horizontalPadding = 20.0
}

// MARK: - Model
private struct PlusFeature: Identifiable, Equatable {
    let iconName: String
    let title: String
    let description: String
    var id: String { title }

    static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
}

// MARK: - Internal Views
private struct PlusLabel: View {
    enum PlusLabelStyle {
        case title
        case subtitle
        case featureTitle
        case featureDescription
    }

    let text: String
    let labelStyle: PlusLabelStyle

    init(_ text: String, for style: PlusLabelStyle) {
        self.text = text
        self.labelStyle = style
    }

    var body: some View {
        Text(text)
            .foregroundColor(Color.textColor)
            .fixedSize(horizontal: false, vertical: true)
            .modifier(LabelFont(labelStyle: labelStyle))
    }

    private struct LabelFont: ViewModifier {
        let labelStyle: PlusLabelStyle

        func body(content: Content) -> some View {
            switch labelStyle {
            case .title:
                return content.font(size: 30, style: .title, weight: .bold, maxSizeCategory: .extraExtraLarge)
            case .subtitle:
                return content.font(size: 18, style: .body, weight: .regular, maxSizeCategory: .extraExtraLarge)
            case .featureTitle:
                return content.font(style: .footnote, maxSizeCategory: .extraExtraLarge)
            case .featureDescription:
                return content.font(style: .footnote, maxSizeCategory: .extraExtraLarge)
            }
        }
    }
}

private struct PlusBackgroundGradientView: View {
    @ProportionalValue(with: .width) var leftCircleSize = 0.836
    @ProportionalValue(with: .width) var leftCircleX = -0.28533333
    @ProportionalValue(with: .height) var leftCircleY = -0.10810811

    @ProportionalValue(with: .width) var rightCircleSize = 0.63866667
    @ProportionalValue(with: .width) var rightCircleX = 0.54133333
    @ProportionalValue(with: .height) var rightCircleY = -0.03316953

    var body: some View {
        ZStack {
            Color.backgroundColor
            ZStack {
                // Right Circle
                Circle()
                    .foregroundColor(.rightCircleColor)
                    .frame(height: rightCircleSize)
                    .position(x: rightCircleX, y: rightCircleY)
                    .offset(x: rightCircleSize * 0.5, y: rightCircleSize * 0.5)

                // Left Circle
                Circle()
                    .foregroundColor(.leftCircleColor)
                    .frame(height: leftCircleSize)
                    .position(x: leftCircleX, y: leftCircleY)
                    .offset(x: leftCircleSize * 0.5, y: leftCircleSize * 0.5)
            }.blur(radius: 100)

            // Overlay view
            Rectangle()
                .foregroundColor(.backgroundColor)
                .opacity(0.28)
        }.ignoresSafeArea().clipped()
    }
}

private struct CardView: View {
    let model: PlusFeature
    let isLast: Bool

    init(model: PlusFeature, isLast: Bool) {
        self.model = model
        self.isLast = isLast
    }

    var body: some View {
        ZStack {
            BackgroundView()

            VStack(alignment: .leading, spacing: 5) {
                Image(model.iconName)
                PlusLabel(model.title, for: .featureTitle)
                    .padding(.top, 10)

                PlusLabel(model.description, for: .featureDescription)
                    .opacity(0.72)
                Spacer()
            }
            .padding(.top, 20)
            .padding([.leading, .trailing], ViewConfig.padding.featureCardMargin)

        }.frame(width: 155, height: 180)
            .padding(.leading, ViewConfig.padding.featureCardMargin)
            .padding(.trailing, isLast ? ViewConfig.padding.featureCardMargin : 0)
    }

    struct BackgroundView: View {
        func backgroundView() -> RoundedRectangle {
            RoundedRectangle(cornerRadius: 12.0)
        }

        var body: some View {
            backgroundView().fill(Color.cardGradient).overlay(
                backgroundView().stroke(Color.cardStroke, lineWidth: 1)
            )
        }
    }
}

// MARK: - Preview
struct PlusIntroView_Preview: PreviewProvider {
    static var previews: some View {
        PlusLandingView(coordinator: PlusCoordinator())
            .setupDefaultEnvironment()
    }
}
