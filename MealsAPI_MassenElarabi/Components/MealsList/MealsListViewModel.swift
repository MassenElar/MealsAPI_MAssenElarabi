//
//  MealListViewModel.swift
//  MealsAPI_MassenElarabi
//
//  Created by Massen Elarabi on 7/9/24.
//

import Foundation

@MainActor
class MealsListViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var meals: [MealDetailsModel] = []
    @Published var error: String?
    @Published var selectedRow: MealDetailsModel?
    var webService: MealsWebServiceProtocol
    
    // MARK: - Initializer
    init(webService: MealsWebServiceProtocol = MealsWebService()) {
        self.webService = webService
    }
    
    // MARK: - functions
    func fetchMeals() async {
        do {
            self.meals = try await webService.fetchMealsList().meals
        } catch (let error) {
            self.error = error.localizedDescription
            print(error)
        }
    }
    
}
