//
//  MockWebService.swift
//  MealsAPI_MassenElarabiTests
//
//  Created by Massen Elarabi on 7/11/24.
//

import Foundation
@testable import MealsAPI_MassenElarabi

extension MealsListModel {
    static func build() async throws -> MealsListModel? {
        let jsonFile = """
        {
            "meals": [
                {
                    "strMeal": "meal1",
                    "strMealThumb": "www.test1.com",
                    "idMeal": "111"
                },
                {
                    "strMeal": "meal2",
                    "strMealThumb": "www.test2.com",
                    "idMeal": "222"
                },
                {
                    "strMeal": "meal3",
                    "strMealThumb": "www.test3.com",
                    "idMeal": "222"
                }
            ]
        }
        """.data(using: .utf8)!
        guard let response = try? JSONDecoder().decode(MealsListModel.self, from: jsonFile) else {
            return nil
        }
        return response
    }
}

extension MealDetailsModel {
    static func build() async throws -> [MealDetailsModel]? {
        let jsonFile = """
        [
            {
                "strMeal": "meal1",
                "strMealThumb": "www.test1.com",
                "idMeal": "111",
                "strInstructions": "Inst1",
                "strIngredient1": "ingrd1",
                "strIngredient2": "ingrd2",
                "strIngredient3": "ingrd3",
                "strMeasure1": "measr1",
                "strMeasure2": "measr2",
                "strMeasure3": "measr3"
            },
            {
                "strMeal": "meal2",
                "strMealThumb": "www.test2.com",
                "idMeal": "222",
                "strInstructions": "Inst2",
                "strIngredient1": "ingrd1",
                "strIngredient2": "ingrd2",
                "strIngredient3": "ingrd3",
                "strMeasure1": "measr1",
                "strMeasure2": "measr2",
                "strMeasure3": "measr3"
            },
            {
                "strMeal": "meal3",
                "strMealThumb": "www.test3.com",
                "idMeal": "333",
                "strInstructions": "Inst3",
                "strIngredient1": "ingrd1",
                "strIngredient2": "ingrd2",
                "strIngredient3": "ingrd3",
                "strMeasure1": "measr1",
                "strMeasure2": "measr2",
                "strMeasure3": "measr3"
            }
        ]
        """.data(using: .utf8)!
        guard let response = try? JSONDecoder().decode([MealDetailsModel].self, from: jsonFile) else {
            return nil
        }
        return response
    }
}

struct MockWebServiceSuccess: MealsWebServiceProtocol {
    
    func fetchMealsList() async throws -> MealsListModel {
        return  try await MealsListModel.build()!
    }
    
    func fetchMealDetails(id: String) async throws -> MealsListModel {
        let mealDetails = try await MealDetailsModel.build()?.filter({ $0.idMeal == id})
        return MealsListModel(meals: mealDetails!)
    }
}

struct MockWebServiceFail: MealsWebServiceProtocol {
    func fetchMealsList() async throws -> MealsListModel {
        throw APIError.httpStatusCode(400)
    }
    
    func fetchMealDetails(id: String) async throws -> MealsListModel {
        throw APIError.httpStatusCode(400)
    }
}
