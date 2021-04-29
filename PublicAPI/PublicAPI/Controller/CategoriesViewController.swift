//
//  CategoriesViewController.swift
//  PublicAPI
//
//  Created by Anuj Joshi on 29/04/2021.
//

import UIKit

class CategoriesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var categories: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Categories"
        navigationController?.navigationBar.prefersLargeTitles = true

        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")

        DataManager.fetchCategories { (categories) in
            self.categories = categories

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }


}
extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let categories = categories else { return 0 }

        if section == 0 {
            return 1
        } else {
            return categories.count - 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)

        guard let categories = categories else { return cell }

        if indexPath.section == 0 {
            cell.textLabel?.text = categories[0]
        } else {
            cell.textLabel?.text = categories[indexPath.row + 1]
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let categories = categories else { return }

        var category: String

        if indexPath.section == 0 {
            category = categories[0]
        } else {
            category = categories[indexPath.row + 1]
        }

//        let apisViewController = APIsViewController(style: .plain)
//        apisViewController.category = category
//
//        navigationController?.pushViewController(apisViewController, animated: true)
    }

}


