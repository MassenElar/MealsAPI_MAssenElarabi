//
//  MealListModel.swift
//  MealsAPI_MassenElarabi
//
//  Created by Massen Elarabi on 7/9/24.
//

import Foundation

struct MealsListModel: Decodable {
    let meals: [MealDetailsModel]
}
