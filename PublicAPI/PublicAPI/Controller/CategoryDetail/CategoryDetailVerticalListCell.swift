//
//  CategoryDetailVerticalListCell.swift
//  PublicAPI
//
//  Created by Anuj Joshi on 30/04/2021.
//

import Foundation
import UIKit

class CategoryDetailVerticalListCell: UICollectionViewListCell {

    var item: Entry?

    override func updateConfiguration(using state: UICellConfigurationState) {

        // Create a new background configuration so that
        // the cell must always have systemBackground background color
        // This will remove the gray background when cell is selected
        var newBgConfiguration = UIBackgroundConfiguration.listGroupedCell()
        newBgConfiguration.backgroundColor = .systemBackground
        backgroundConfiguration = newBgConfiguration

        // Create new configuration object and update it base on state
        var newConfiguration = CategoryDetailContentConfiguration().updated(for: state)

        // Update any configuration parameters related to data item
        newConfiguration.name = item?.api
        newConfiguration.description = item?.description

        // Set content configuration in order to update custom content view
        contentConfiguration = newConfiguration

    }
}
