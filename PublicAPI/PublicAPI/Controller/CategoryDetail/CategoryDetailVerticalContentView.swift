//
// CategoryDetailVerticalContentView.swift
//  PublicAPI
//
//  Created by Anuj Joshi on 30/04/2021.
//

import Foundation
import UIKit

class CategoryDetailVerticalContentView: UIView, UIContentView {

    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    //let symbolImageView = UIImageView()

    private var currentConfiguration: CategoryDetailContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        set {
            // Make sure the given configuration is of type SFSymbolContentConfiguration
            guard let newConfiguration = newValue as? CategoryDetailContentConfiguration else {
                return
            }

            // Apply the new configuration to SFSymbolVerticalContentView
            // also update currentConfiguration to newConfiguration
            apply(configuration: newConfiguration)
        }
    }


    init(configuration: CategoryDetailContentConfiguration) {
        super.init(frame: .zero)

        // Create the content view UI
        setupAllViews()

        // Apply the configuration (set data to UI elements / define custom content view appearance)
        apply(configuration: configuration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension CategoryDetailVerticalContentView {

    private func setupAllViews() {

        // Add stack view to content view
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])

        // Add image view to stack view
       // symbolImageView.contentMode = .scaleAspectFit
       // stackView.addArrangedSubview(symbolImageView)

        // Add label to stack view
        nameLabel.textAlignment = .center
        descriptionLabel.textAlignment = .center
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }

    private func apply(configuration: CategoryDetailContentConfiguration) {

        // Only apply configuration if new configuration and current configuration are not the same
        guard currentConfiguration != configuration else {
            return
        }

        // Replace current configuration with new configuration
        currentConfiguration = configuration

        // Set data to UI elements
        nameLabel.text = configuration.name
        nameLabel.textColor = configuration.nameColor

        descriptionLabel.text = configuration.description
        descriptionLabel.textColor = configuration.symbolColor
        // Set font weight
        if let fontWeight = configuration.fontWeight {
            nameLabel.font = UIFont.systemFont(ofSize: nameLabel.font.pointSize,
                                               weight: fontWeight)
        }

//        // Set symbol color & weight
//        if
//            let symbolColor = configuration.symbolColor,
//            let symbolWeight = configuration.symbolWeight {
//
//            let symbolConfig = UIImage.SymbolConfiguration(weight: symbolWeight)
//            var symbol = configuration.symbol?.withConfiguration(symbolConfig)
//            symbol = symbol?.withTintColor(symbolColor, renderingMode: .alwaysOriginal)
//           // symbolImageView.image = symbol
//        }
    }
}
