//
//  StepProgressBarEntity.swift
//  BurakKit
//

import Foundation

public struct StepProgressBarEntity {
    public var binding: Binding
    public var config: Config

    public init(binding: Binding, config: Config) {
        self.binding = binding
        self.config = config
    }

    public enum SegmentShape: Equatable, Sendable {
        case roundedRectangle(cornerRadius: CGFloat)
        case capsule
        case circle
    }
}
