//
//  MealListViewModelTests.swift
//  MealsAPI_MassenElarabiTests
//
//  Created by Massen Elarabi on 7/11/24.
//

import XCTest
@testable import MealsAPI_MassenElarabi

final class MealListViewModelTests: XCTestCase {
    
    var sut: MealsListViewModel!

    @MainActor
    override func setUpWithError() throws {
        sut = MealsListViewModel(webService: MockWebServiceSuccess())
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testFetchMealsListSuccess() async {
        await sut.fetchMeals()
        let meals = await sut.meals
        XCTAssertEqual(meals.count, 3)
        XCTAssertEqual(meals.first?.idMeal, "111")
        XCTAssertEqual(meals[2].idMeal, "222")
    }
    
    func testFetchMealsFail() async {
        sut = await MealsListViewModel(webService: MockWebServiceFail())
        await sut.fetchMeals()
        let meals = await sut.meals
        let error = await sut.error
        XCTAssertTrue(meals.isEmpty)
        XCTAssertEqual(error, "Unexpected HTTP status code: 400")
    }

}
