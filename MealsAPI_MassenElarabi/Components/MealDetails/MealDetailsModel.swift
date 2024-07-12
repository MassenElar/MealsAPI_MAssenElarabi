//
//  MealDetailsModel.swift
//  MealsAPI_MassenElarabi
//
//  Created by Massen Elarabi on 7/9/24.
//

import Foundation

struct MealDetailsModel: Decodable {
    var idMeal: String
    var strMeal: String
    var strMealThumb: String
    var strInstructions: String?
    var ingredients: [String: String]? = [:]
    var measurements: [String: String]? = [:]
    
    struct CodingKeys: CodingKey, Hashable {
        
        var stringValue: String
        
        static let idMeal = CodingKeys(stringValue: "idMeal")
        static let strMeal = CodingKeys(stringValue: "strMeal")
        static let strMealThumb = CodingKeys(stringValue: "strMealThumb")
        static let strInstructions = CodingKeys(stringValue: "strInstructions")
        
        init(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idMeal = try container.decode(String.self, forKey: .idMeal)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strInstructions = try container.decodeIfPresent(String.self, forKey: .strInstructions)
        strMealThumb = try container.decode(String.self, forKey: .strMealThumb)
        
        let keys = container.allKeys
        for key in keys {
            if key.stringValue.hasPrefix("strIngredient") {
                ingredients?[key.stringValue] = try container.decodeIfPresent(String.self, forKey: key)
            } else if key.stringValue.hasPrefix("strMeasure") {
                measurements?[key.stringValue] = try container.decodeIfPresent(String.self, forKey: key)
            }
        }
    }
}
