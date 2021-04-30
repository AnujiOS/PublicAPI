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
    var resultSearchController = UISearchController()

    var searchcategories = [String]()
    var category = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Categories"
        navigationController?.navigationBar.prefersLargeTitles = true
    
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        let spinner = showLoader(view: self.view)

        resultSearchController = ({
                let controller = UISearchController(searchResultsController: nil)
                controller.searchResultsUpdater = self
                controller.dimsBackgroundDuringPresentation = false
                controller.searchBar.sizeToFit()

                tableView.tableHeaderView = controller.searchBar

                return controller
            })()

        DataManager.fetchCategories { (categories) in
            self.categories = categories

            DispatchQueue.main.async {
                self.tableView.reloadData()
                spinner.dismissLoader()
            }
        }
    }
    func showLoader(view: UIView) -> UIActivityIndicatorView {

            //Customize as per your need
            let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height:60))
            spinner.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            spinner.layer.cornerRadius = 3.0
            spinner.clipsToBounds = true
            spinner.hidesWhenStopped = true
            spinner.style = UIActivityIndicatorView.Style.medium
            spinner.center = view.center
            view.addSubview(spinner)
            spinner.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()

            return spinner
        }
}
extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let categories = categories else { return 0 }

        if (resultSearchController.isActive){
            return searchcategories.count
        }else {
            if section == 0 {
                return 1
            } else {
                return categories.count - 1
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)

        if (resultSearchController.isActive){
            cell.textLabel?.text = searchcategories[indexPath.row]
        }else {
            guard let categories = categories else { return cell }

            if indexPath.section == 0 {
                cell.textLabel?.text = categories[0]
            } else {
                cell.textLabel?.text = categories[indexPath.row + 1]
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if (resultSearchController.isActive){
            guard  searchcategories != nil else {
                return
            }
            category = searchcategories[indexPath.row]
        }else {
            guard let categories = categories else { return }


            if indexPath.section == 0 {
                category = categories[0]
            } else {
                category = categories[indexPath.row + 1]
            }
        }
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toDetailVC", sender: self)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            let destinationVC = segue.destination as? CategoriesDetailViewController
                destinationVC?.category = category
        }
    }
}


extension CategoriesViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        searchcategories.removeAll(keepingCapacity: false)

        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (categories! as NSArray).filtered(using: searchPredicate)
        searchcategories = array as! [String]

        self.tableView.reloadData()
    }
}

extension UIActivityIndicatorView {
     func dismissLoader() {
            self.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
 }
