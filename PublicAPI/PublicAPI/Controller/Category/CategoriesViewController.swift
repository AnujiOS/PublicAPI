//
//  CategoriesViewController.swift
//  PublicAPI
//
//  Created by Anuj Joshi on 29/04/2021.
//

import UIKit
import CoreData

class CategoriesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var categories: [String]?
    var searchcategories = [String]()
    var category = String()

    let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
    var context:NSManagedObjectContext!

    let categoryViewModel = CategoryListViewModel()
    var categoryService = CategoryService()

    private var isLoading = false

    let reachability = try! Reachability()

    override func viewDidLoad() {
        super.viewDidLoad()

        //Navigation Setup
        navigationItem.title = "Categories"
        navigationController?.navigationBar.prefersLargeTitles = true

        //Tableview Setup
        self.tableViewSetup()

        self.fetchAllCategories()
    }

        func fetchAllCategories(){
            guard !isLoading else { return }
    
            isLoading = true
    
            categoryService.fetchCategories { (result) in
                self.isLoading = false
                DispatchQueue.main.async {
                    switch result {
                    case .failure( _):
                        break
                    case .success(let categories):
                        self.categories = categories
                        self.tableView.reloadData()
                        self.categoryViewModel.spinner.dismissLoader()
                        self.openDatabase()
                    }
                }
            }
        }

    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object:reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

    

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }

    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability

        switch reachability.connection {
        case .wifi:
            print("Wifi Connection")
        case .cellular:
            print("Cellular Connection")
        case .unavailable:
            print("No Connection")
            self.fetchData()
        case .none:
            print("No Connection")
        }
    }
}

// MARK: - TableView

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableViewSetup() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        categoryViewModel.spinner = categoryViewModel.showLoader(view: self.view)
        
        categoryViewModel.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let categories = categories else { return 0 }
        
        if (categoryViewModel.resultSearchController.isActive){
            return searchcategories.count
        }else {
            return categories.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        if (categoryViewModel.resultSearchController.isActive){
            cell.textLabel?.text = searchcategories[indexPath.row]
        }else {
            guard let categories = categories else { return cell }
            
            cell.textLabel?.text = categories[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (categoryViewModel.resultSearchController.isActive){
            guard  searchcategories != nil else {
                return
            }
            category = searchcategories[indexPath.row]
        }else {
            guard let categories = categories else { return }

                category = categories[indexPath.row]
        }
        DispatchQueue.main.async {
            self.categoryViewModel.resultSearchController.dismiss(animated: false, completion: nil)
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
        if categories != nil{
            let array = (categories! as NSArray).filtered(using: searchPredicate)
            searchcategories = array as! [String]
        }

        self.tableView.reloadData()
    }
}

extension UIActivityIndicatorView {
     func dismissLoader() {
            self.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
 }

// MARK: Methods to Open, Store and Fetch data

extension CategoriesViewController {
       func openDatabase()
       {
           context = appDelegate.persistentContainer.viewContext
           let entity = NSEntityDescription.entity(forEntityName: "Categories", in: context)
           let newCategories = NSManagedObject(entity: entity!, insertInto: context)
           saveData(UserDBObj:newCategories)
       }
    func saveData(UserDBObj:NSManagedObject)
        {
            UserDBObj.setValue(categories, forKey:"name")
            print("Storing Data..")
            do {
                try context.save()
            } catch {
                print("Storing data Failed")
            }
            fetchData()
        }

    func fetchData()
        {
            print("Fetching Data..")
            context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Categories", in: context)
            let newCategories = NSManagedObject(entity: entity!, insertInto: context)
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {
                    let name = data.value(forKey: "name")

                    if categories?.count == nil {
                        if name != nil{
                            self.categories = name as? [String]
                            self.categoryViewModel.spinner.dismissLoader()
                            self.tableView.reloadData()
                        }else {
                            self.categoryViewModel.spinner.dismissLoader()
                            let alert = UIAlertController(title: "Alert",
                                                          message: "Please connect to Internet",
                                                          preferredStyle: .alert)

                            let okAction = UIAlertAction(title:"OK", style: .default, handler: { (_) in })
                            alert.addAction(okAction)

                            present(alert, animated: true, completion:nil)
                        }
                    }
                }
            } catch {
                print("Fetching data Failed")
            }
        }
}
