//
//  StepProgressBar.swift
//  BurakKit
//

import SwiftUI

public struct StepProgressBar: View, @MainActor Equatable {

    public enum Action {
        case didTapBack
        case didTapSkip
    }

    @Binding var binding: StepProgressBarEntity.Binding
    let config: StepProgressBarEntity.Config
    let onAction: (Action) -> Void

    public init(
        binding: SwiftUI.Binding<StepProgressBarEntity.Binding>,
        config: StepProgressBarEntity.Config,
        onAction: @escaping (Action) -> Void
    ) {
        self._binding = binding
        self.config = config
        self.onAction = onAction
    }

    // MARK: - Body Layout
    // To add a new shape:
    // 1. Add case to SegmentShape enum
    // 2. Add case to the switch below
    // 3. Implement the layout method (use shared helpers: backButton, skipButton, filledGradient)

    @ViewBuilder
    public var body: some View {
        switch config.segmentShape {
        case .roundedRectangle(let cornerRadius):
            barLayout(cornerRadius: cornerRadius)
        case .capsule:
            barLayout(cornerRadius: config.segmentHeight / 2)
        case .circle:
            circleLayout
        }
    }

    // MARK: - Bar Layout (Rounded Rectangle & Capsule)

    private func barLayout(cornerRadius: CGFloat) -> some View {
        HStack(spacing: 8) {
            backButton
                .opacity(isBackVisible ? 1 : 0)
                .allowsHitTesting(isBackVisible)

            HStack(spacing: config.segmentSpacing) {
                ForEach(0..<config.totalSteps, id: \.self) { index in
                    if index < binding.currentStep {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(filledGradient)
                            .frame(height: config.segmentHeight)
                    } else {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(config.unfilledColor)
                            .frame(height: config.segmentHeight)
                    }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: binding.currentStep)

            if !config.skippableSteps.isEmpty {
                skipButton
                    .opacity(isSkipVisible ? 1 : 0)
                    .allowsHitTesting(isSkipVisible)
            }
        }
        .padding(.leading, 12)
        .padding(.trailing, 24)
        .frame(height: 28)
    }

    // MARK: - Circle Layout

    private var circleLayout: some View {
        HStack(spacing: 12) {
            backButton
                .opacity(isBackVisible ? 1 : 0)
                .allowsHitTesting(isBackVisible)

            Spacer()

            HStack(spacing: config.segmentSpacing) {
                ForEach(0..<config.totalSteps, id: \.self) { index in
                    if index < binding.currentStep {
                        Circle()
                            .fill(filledGradient)
                            .frame(width: config.segmentHeight, height: config.segmentHeight)
                    } else {
                        Circle()
                            .fill(config.unfilledColor)
                            .frame(width: config.segmentHeight, height: config.segmentHeight)
                    }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: binding.currentStep)

            Spacer()

            if !config.skippableSteps.isEmpty {
                skipButton
                    .opacity(isSkipVisible ? 1 : 0)
                    .allowsHitTesting(isSkipVisible)
            }
        }
        .padding(.horizontal, 24)
        .frame(height: 28)
    }

    // MARK: - Shared Components

    private var backButton: some View {
        Button {
            onAction(.didTapBack)
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: config.backButtonIconSize, weight: .medium))
                .foregroundColor(config.backButtonColor)
                .frame(width: 28, height: 28)
        }
    }

    private var skipButton: some View {
        Button {
            onAction(.didTapSkip)
        } label: {
            Text(config.skipTitle)
                .font(config.skipFont)
                .foregroundColor(config.skipTitleColor)
        }
    }

    private var filledGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: config.filledGradientColors),
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var isBackVisible: Bool {
        binding.currentStep > 0
    }

    private var isSkipVisible: Bool {
        config.skippableSteps.contains(binding.currentStep)
    }

    public static func == (lhs: StepProgressBar, rhs: StepProgressBar) -> Bool {
        lhs.binding == rhs.binding
        && lhs.config == rhs.config
    }
}

// MARK: - Preview Helpers

private struct PreviewPage<Content: View>: View {
    @SwiftUI.Binding var entity: StepProgressBarEntity
    let title: String
    let subtitle: String
    let content: Content

    init(
        entity: SwiftUI.Binding<StepProgressBarEntity>,
        title: String,
        subtitle: String,
        @ViewBuilder content: () -> Content
    ) {
        self._entity = entity
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            StepProgressBar(
                binding: $entity.binding,
                config: entity.config,
                onAction: { action in
                    switch action {
                    case .didTapBack:
                        if entity.binding.currentStep > 0 {
                            entity.binding.currentStep -= 1
                        }
                    case .didTapSkip:
                        if entity.binding.currentStep < entity.config.totalSteps {
                            entity.binding.currentStep += 1
                        }
                    }
                }
            )

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(red: 15.0 / 255, green: 23.0 / 255, blue: 42.0 / 255))

                Text(subtitle)
                    .font(.system(size: 15))
                    .foregroundColor(Color(red: 100.0 / 255, green: 116.0 / 255, blue: 139.0 / 255))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.top, 24)

            content

            Spacer()

            HStack(spacing: 12) {
                Button {
                    if entity.binding.currentStep > 0 {
                        entity.binding.currentStep -= 1
                    }
                } label: {
                    Text("Back")
                        .font(.system(size: 16, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(red: 241.0 / 255, green: 245.0 / 255, blue: 249.0 / 255))
                        .cornerRadius(14)
                }

                Button {
                    if entity.binding.currentStep < entity.config.totalSteps {
                        entity.binding.currentStep += 1
                    }
                } label: {
                    Text("Continue")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 30.0 / 255, green: 58.0 / 255, blue: 95.0 / 255),
                                    Color(red: 59.0 / 255, green: 130.0 / 255, blue: 246.0 / 255)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(14)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
        .background(Color.white)
    }
}

// MARK: - Previews

private struct OnboardingPreview: View {
    @State var entity = StepProgressBarEntity(
        binding: .init(currentStep: 0),
        config: .init(
            totalSteps: 10,
            skippableSteps: [0, 1, 2, 3, 4]
        )
    )

    var body: some View {
        PreviewPage(
            entity: $entity,
            title: "Select your currency",
            subtitle: "Step \(entity.binding.currentStep) of \(entity.config.totalSteps)"
        ) { EmptyView() }
    }
}

private struct CapsulePreview: View {
    @State var entity = StepProgressBarEntity(
        binding: .init(currentStep: 3),
        config: .init(
            totalSteps: 5,
            skippableSteps: [1, 2, 3],
            segmentHeight: 6,
            segmentSpacing: 6,
            segmentShape: .capsule,
            filledGradientColors: [
                Color(red: 16.0 / 255, green: 185.0 / 255, blue: 129.0 / 255),
                .green
            ]
        )
    )

    var body: some View {
        PreviewPage(
            entity: $entity,
            title: "Profile setup",
            subtitle: "Step \(entity.binding.currentStep) of \(entity.config.totalSteps)"
        ) { EmptyView() }
    }
}

private struct CirclePreview: View {
    @State var entity = StepProgressBarEntity(
        binding: .init(currentStep: 2),
        config: .init(
            totalSteps: 6,
            skippableSteps: [0, 1],
            segmentHeight: 8,
            segmentSpacing: 8,
            segmentShape: .circle,
            filledGradientColors: [
                Color(red: 124.0 / 255, green: 58.0 / 255, blue: 237.0 / 255),
                Color(red: 168.0 / 255, green: 85.0 / 255, blue: 247.0 / 255)
            ]
        )
    )

    var body: some View {
        PreviewPage(
            entity: $entity,
            title: "Verification",
            subtitle: "Step \(entity.binding.currentStep) of \(entity.config.totalSteps)"
        ) { EmptyView() }
    }
}

#Preview("Rounded Rectangle - With Skip") {
    OnboardingPreview()
}

#Preview("Capsule") {
    CapsulePreview()
}

#Preview("Circle") {
    CirclePreview()
}
