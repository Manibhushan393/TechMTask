//
//  TechMTaskTests.swift
//  TechMTaskTests
//
//  Created by Mani bhushan M on 14/02/22.
//

import XCTest
@testable import TechMTask

class TechMTaskTests: XCTestCase {

    func testGetUsersAPICall() {
        //ARRANGE
        let url = "http://api.github.com/search/users"
        let expectation = self.expectation(description: "UsersApiCall")
        //ACTION
        APIManager.sharedInstance.getUserData(url_str: url, page: 0, per_page_items: 10, completion: { (status_code , response) in
        //ASSERT
            XCTAssertNotNil(response)
            XCTAssertEqual(status_code, 200)
            expectation.fulfill()
            
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSearchUsersAPICall() {
        //ARRANGE
        let url = "http://api.github.com/search/users"
        let search_user = "Manibhushan393"
        let expectation = self.expectation(description: "SearchUsersApiCall")
        //ACTION
        APIManager.sharedInstance.getSearchedUsersData(url_str: url, search_term: search_user,page: 0, per_page_items: 10, completion: { (status_code , response) in
        //ASSERT
            XCTAssertNotNil(response)
            XCTAssertEqual(status_code, 200)
            XCTAssertEqual(search_user.lowercased(), response?.items?.map({$0.login?.lowercased()}).first)
            expectation.fulfill()
            
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
}
