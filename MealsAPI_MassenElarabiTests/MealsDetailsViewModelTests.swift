//
//  MealsDetailsViewModelTests.swift
//  MealsAPI_MassenElarabiTests
//
//  Created by Massen Elarabi on 7/11/24.
//

import XCTest
@testable import MealsAPI_MassenElarabi

final class MealDetailsViewModelTests: XCTestCase {
    
    var sut: MealDetailsViewModel!

    @MainActor
    override func setUpWithError() throws {
        sut = MealDetailsViewModel(id: "111", webService: MockWebServiceSuccess())
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testFetchMealsDetailsSuccess() async {
        await sut.fetchDetails(id: "111")
        let meal1 = await sut.mealDetails
        XCTAssertEqual(meal1?.idMeal, "111")
        XCTAssertEqual(meal1?.strMeal, "meal1")
        XCTAssertEqual(meal1?.ingredients?.count, 3)
        XCTAssertEqual(meal1?.ingredients?["strIngredient1"], "ingrd1")
        await sut.fetchDetails(id: "222")
        let meal2 = await sut.mealDetails
        XCTAssertEqual(meal2?.idMeal, "222")
        XCTAssertEqual(meal2?.strMeal, "meal2")
        XCTAssertEqual(meal2?.ingredients?.count, 3)
        XCTAssertEqual(meal1?.measurements?["strMeasure2"], "measr2")
    }
    
    func testPrecessData() async {
        await sut.fetchDetails(id: "111")
        let ingredients = await sut.processData()
        XCTAssertEqual(ingredients?.count, 3)
        XCTAssertEqual(ingredients?[0].key, "ingrd1")
        XCTAssertEqual(ingredients?[0].value, "measr1")
        XCTAssertEqual(ingredients?[2].key, "ingrd3")
        XCTAssertEqual(ingredients?[2].value, "measr3")
    }
    
    func testSortData() async {
        let keys = [
            "key1": "value1",
            "key3": "value3",
            "key4": "  ",
            "key2": "value2",
            "key7": "value7",
            "key6": "",
            "key5": "value5"
        ]
        let sortedData = await sut.sortData(data: keys)
        XCTAssertEqual(sortedData[0], "value1")
        XCTAssertEqual(sortedData[1], "value2")
        XCTAssertEqual(sortedData[2], "value3")
        XCTAssertEqual(sortedData[3], "value5")
    }
    
    func testFetchMealsFail() async {
        sut = await MealDetailsViewModel(id: "111", webService: MockWebServiceFail())
        await sut.fetchDetails(id: "111")
        let meal = await sut.mealDetails
        let error = await sut.errorDescription
        XCTAssertNil(meal)
        XCTAssertEqual(error, "Unexpected HTTP status code: 400")
    }

}
