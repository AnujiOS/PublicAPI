//
//  CategoryListNetworkServiceTest.swift
//  PublicAPITests
//
//  Created by Anuj Joshi on 01/05/2021.
//
@testable import PublicAPI
import XCTest

class CategoryListNetworkServiceTest: XCTestCase {

    func testFetchBeaches() {
        let engine = URLSession.shared
        let service = CategoryService(engine: engine)
        let expectation = self.expectation(description: #function)

        service.fetchCategories(with: { result in
            switch result {
            case .success(let category):
                XCTAssertNotNil(category)
                XCTAssertFalse(category.isEmpty)
                expectation.fulfill()
            case .failure(let error):
                print(error)
                XCTFail(String(describing: error))
            }
        })
        waitForExpectations(timeout: 5)
    }

}
