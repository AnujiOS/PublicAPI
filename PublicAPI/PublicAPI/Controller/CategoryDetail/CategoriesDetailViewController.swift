//
//  CategoriesDetailViewController.swift
//  PublicAPI
//
//  Created by Anuj Joshi on 30/04/2021.
//

import UIKit

class CategoriesDetailViewController: UIViewController {
    var category: String?
    var entries: [Entry]?

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Entry>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, Entry>!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("CategoriesDetailViewController")

        navigationItem.title = category

        // Create list layout
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)

        // Define right-to-left swipe action
        layoutConfig.trailingSwipeActionsConfigurationProvider = { [unowned self] (indexPath) in

            guard let item = dataSource.itemIdentifier(for: indexPath) else {
                return nil
            }

            // Create action 1
            let action1 = UIContextualAction(style: .normal, title: "Action 1") { (action, view, completion) in

                // Handle swipe action by showing an alert message
                handleSwipe(for: action, item: item)

                // Trigger the action completion handler
                completion(true)
            }
            action1.backgroundColor = .systemGreen

            // Create action 2
            let action2 = UIContextualAction(style: .normal, title: "Action 2") { (action, view, completion) in

                // Handle swipe action by showing alert message
                handleSwipe(for: action, item: item)

                // Trigger the action completion handler
                completion(true)
            }
            action2.backgroundColor = .systemPink

            // Use all the actions to create a swipe action configuration
            // Return it to the swipe action configuration provider
            return UISwipeActionsConfiguration(actions: [action2, action1])
        }

        // Create list layout

        // Create collection view with list layout
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
        view.addSubview(collectionView)

        // Make collection view take up the entire view
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
        ])

        // Create cell registration that define how data should be shown in a cell
        let cellRegistration = UICollectionView.CellRegistration<CategoryDetailVerticalListCell, Entry> { (cell, indexPath, item) in

            // For custom cell, we just need to assign the data item to the cell.
            // The custom cell's updateConfiguration(using:) method will assign the
            // content configuration to the cell
            cell.item = item
        }

        if let category = category {
            DataManager.fetchEntries(category: category) { (entries) in
                self.entries = entries

                DispatchQueue.main.async {
                  //  self.collectionView.reloadData()
                    // Define data source
                    self.dataSource = UICollectionViewDiffableDataSource<Section, Entry>(collectionView: self.collectionView) {
                        (collectionView: UICollectionView, indexPath: IndexPath, identifier: Entry) -> UICollectionViewCell? in

                        // Dequeue reusable cell using cell registration (Reuse identifier no longer needed)
                        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                                for: indexPath,
                                                                                item: identifier)

                        return cell
                    }

                    // Create a snapshot that define the current state of data source's data
                    self.snapshot = NSDiffableDataSourceSnapshot<Section, Entry>()
                    self.snapshot.appendSections([.main])

                    self.snapshot.appendItems(entries, toSection: .main)
                        // Display data on the collection view by applying the snapshot to data source
                    self.dataSource.apply(self.snapshot, animatingDifferences: false)
                }
            }
        }

    }
}

private extension CategoriesDetailViewController {

    func handleSwipe(for action: UIContextualAction, item: Entry) {

        let alert = UIAlertController(title: action.title,
                                      message: item.description,
                                      preferredStyle: .alert)

        let okAction = UIAlertAction(title:"OK", style: .default, handler: { (_) in })
        alert.addAction(okAction)

        present(alert, animated: true, completion:nil)
    }
}

extension CategoriesDetailViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        // Retrieve the item identifier using index path.
        // The item identifier we get will be the selected data item
        // NOTE: Do not use dataItems[indexPath.item] (Apple recommends never using index paths as identifiers, as they’re not guaranteed to be stable as list items get inserted and removed.)
        guard let selectedItem = dataSource.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }

        // Show selected SFSymbol's name
        let alert = UIAlertController(title: selectedItem.api,
                                      message: "",
                                      preferredStyle: .alert)

        let okAction = UIAlertAction(title:"OK", style: .default, handler: { (_) in
            // Deselect the selected cell
            collectionView.deselectItem(at: indexPath, animated: true)
        })
        alert.addAction(okAction)

        present(alert, animated: true, completion:nil)
    }
}
