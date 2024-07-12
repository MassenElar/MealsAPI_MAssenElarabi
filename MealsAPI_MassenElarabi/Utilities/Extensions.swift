//
//  Extensions.swift
//  MealsAPI_MassenElarabi
//
//  Created by Massen Elarabi on 7/10/24.
//

import Foundation

extension String {
    func isNonEmptyOrWhitespace() -> Bool {
        return !self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
