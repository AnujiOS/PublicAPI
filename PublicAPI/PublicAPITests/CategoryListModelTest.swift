//
//  CategoryListModelTest.swift
//  PublicAPITests
//
//  Created by Anuj Joshi on 01/05/2021.
//
@testable import PublicAPI
import XCTest

class CategoryListModelTest: XCTestCase {

    class MockArticleService: CategoryService {

        var fetchCalledCounter = 0

        override func fetchCategories(with complete: @escaping (NetworkService.Result<[String]>) -> Void) {
            fetchCalledCounter += 1
        }
    }
}
