//
//  MealDetailsViewModel.swift
//  MealsAPI_MassenElarabi
//
//  Created by Massen Elarabi on 7/9/24.
//

import Foundation


@MainActor
class MealDetailsViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var mealDetails: MealDetailsModel?
    @Published var errorDescription: String = ""
    private var webService: MealsWebServiceProtocol
    var id: String
    
    // MARK: - Initializer
    init(mealDetails: MealDetailsModel? = nil,
         id: String,
         webService: MealsWebServiceProtocol = MealsWebService()) {
        self.mealDetails = mealDetails
        self.id = id
        self.webService = webService
    }
    
    // MARK: - Computed Values
    var mealName: String {
        if let meal = mealDetails {
            return meal.strMeal
        }
        return "N/A"
    }
    
    var instructions: String {
        if let mealInst = mealDetails?.strInstructions {
            return mealInst
        }
        return "N/A"
    }
    
    // functions
    func fetchDetails(id: String) async {
        do {
            mealDetails = try await webService.fetchMealDetails(id: id).meals.first
        } catch(let error) {
            self.errorDescription = error.localizedDescription
            print(error)
        }
    }
    
    func processData() -> [(id: UUID, key: String, value: String)]? {
        var result: [(id: UUID, key: String, value: String)] = []
        var ingredientsArray: [String] = []
        var measurementArray: [String] = []
        guard let ingredients = mealDetails?.ingredients else {
            return nil
        }
        ingredientsArray = sortData(data: ingredients)
        guard let measurements = mealDetails?.measurements  else {
            return nil
        }
        measurementArray = sortData(data: measurements)
        for i in (0..<ingredientsArray.count) {
            result.append((id: UUID(), key: ingredientsArray[i], value: measurementArray[i]))
        }
        return result
    }
    
    func sortData(data: [String: String]) -> [String] {
        var sortedData: [String] = []
        let sortedKeys = data.keys.sorted()
        for key in sortedKeys {
            sortedData.append(data[key] ?? "")
        }
        return sortedData.filter({ $0.isNonEmptyOrWhitespace() })
    }
 
}
