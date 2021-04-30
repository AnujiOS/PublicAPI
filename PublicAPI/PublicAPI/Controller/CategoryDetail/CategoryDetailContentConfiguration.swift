//
//  CategoryDetailContentConfiguration.swift
//  PublicAPI
//
//  Created by Anuj Joshi on 30/04/2021.
//

import Foundation
import UIKit

struct CategoryDetailContentConfiguration: UIContentConfiguration, Hashable {

    var name: String?
    var description: String?
    var symbol: UIImage?
    var nameColor: UIColor?
    var symbolColor: UIColor?
    var symbolWeight: UIImage.SymbolWeight?
    var fontWeight: UIFont.Weight?

    func makeContentView() -> UIView & UIContentView {
        return CategoryDetailVerticalContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> Self {

        // Perform update on parameters that does not related to cell's data itesm

        // Make sure we are dealing with instance of UICellConfigurationState
        guard let state = state as? UICellConfigurationState else {
            return self
        }

        // Updater self based on the current state
        var updatedConfiguration = self
        if state.isSelected {
            // Selected state
            updatedConfiguration.nameColor = .systemPink
            updatedConfiguration.symbolColor = .systemPink
            updatedConfiguration.fontWeight = .heavy
            updatedConfiguration.symbolWeight = .heavy
        } else {
            // Other states
            updatedConfiguration.nameColor = .systemBlue
            updatedConfiguration.symbolColor = .systemBlue
            updatedConfiguration.fontWeight = .regular
            updatedConfiguration.symbolWeight = .regular
        }

        return updatedConfiguration
    }

}
