//
//  StepProgressBarBinding.swift
//  BurakKit
//

import Foundation

extension StepProgressBarEntity {

    public struct Binding: Equatable {
        public var currentStep: Int {
            didSet { currentStep = max(1, currentStep) }
        }

        public init(currentStep: Int = 1) {
            self.currentStep = max(1, currentStep)
        }
    }
}
