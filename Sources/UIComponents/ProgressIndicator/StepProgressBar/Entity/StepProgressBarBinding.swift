//
//  StepProgressBarBinding.swift
//  BurakKit
//

import Foundation

extension StepProgressBarEntity {

    public struct Binding: Equatable {
        public var currentStep: Int

        public init(currentStep: Int = 0) {
            self.currentStep = currentStep
        }
    }
}
