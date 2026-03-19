//
//  StepProgressBarConfig.swift
//  BurakKit
//

import SwiftUI

extension StepProgressBarEntity {

    public struct Config: Equatable {
        public let totalSteps: Int
        public let skippableSteps: Set<Int>

        public let segmentHeight: CGFloat
        public let segmentSpacing: CGFloat
        public let segmentShape: SegmentShape

        public let filledGradientColors: [Color]
        public let unfilledColor: Color

        public let skipTitle: String
        public let skipTitleColor: Color
        public let skipFont: Font

        public let backButtonColor: Color
        public let backButtonIconSize: CGFloat

        public init(
            totalSteps: Int,
            skippableSteps: Set<Int> = [],
            segmentHeight: CGFloat = 4,
            segmentSpacing: CGFloat = 4,
            segmentShape: SegmentShape = .roundedRectangle(cornerRadius: 2),
            filledGradientColors: [Color] = [
                Color(red: 30.0 / 255, green: 58.0 / 255, blue: 95.0 / 255),
                Color(red: 59.0 / 255, green: 130.0 / 255, blue: 246.0 / 255)
            ],
            unfilledColor: Color = Color(red: 15.0 / 255, green: 23.0 / 255, blue: 42.0 / 255, opacity: 0.08),
            skipTitle: String = "Skip",
            skipTitleColor: Color = Color(red: 100.0 / 255, green: 116.0 / 255, blue: 139.0 / 255),
            skipFont: Font = .system(size: 14, weight: .medium),
            backButtonColor: Color = Color(red: 15.0 / 255, green: 23.0 / 255, blue: 42.0 / 255),
            backButtonIconSize: CGFloat = 18
        ) {
            self.totalSteps = totalSteps
            self.skippableSteps = skippableSteps
            self.segmentHeight = segmentHeight
            self.segmentSpacing = segmentSpacing
            self.segmentShape = segmentShape
            self.filledGradientColors = filledGradientColors
            self.unfilledColor = unfilledColor
            self.skipTitle = skipTitle
            self.skipTitleColor = skipTitleColor
            self.skipFont = skipFont
            self.backButtonColor = backButtonColor
            self.backButtonIconSize = backButtonIconSize
        }
    }
}
