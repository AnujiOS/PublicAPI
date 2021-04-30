//
//  CategoryListViewModel.swift
//  PublicAPI
//
//  Created by Anuj Joshi on 30/04/2021.
//

import Foundation
import UIKit
import CoreData

class CategoryListViewModel {
    //This viewmodel class for CategoriesViewController

    var spinner:UIActivityIndicatorView!
    var resultSearchController = UISearchController()

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
