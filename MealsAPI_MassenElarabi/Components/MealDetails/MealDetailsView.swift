//
//  MealDetailsView.swift
//  MealsAPI_MassenElarabi
//
//  Created by Massen Elarabi on 7/9/24.
//

import SwiftUI

struct MealDetailsView: View {
    
    // MARK: - Properties
    @ObservedObject var viewModel: MealDetailsViewModel
    
    // MARK: - Initializer
    init(viewModel: MealDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - UI components
    var body: some View {
        VStack(spacing: 0) {
            Text(viewModel.mealName)
                .font(.largeTitle)
                .foregroundStyle(.blue)
                .padding(.bottom)
            Divider()
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Instructions")
                        .font(.headline)
                        .padding(.vertical)
                    Text(viewModel.instructions)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                    Text("Ingredients And Measurements")
                        .font(.headline)
                        .padding(.vertical)
                    ingredientAndMeasurements
                }
                .padding()
            }
        }
        .task {
            await viewModel.fetchDetails(id: viewModel.id)
        }
    }
    
    @ViewBuilder
    var ingredientAndMeasurements: some View {
        if let data = viewModel.processData() {
            ForEach(data, id: \.id ) { id, key, value in
                HStack {
                    Text("**• \(key)**: \(value)")
                }
            }
        }
    }
}

#Preview {
    MealDetailsView(viewModel: MealDetailsViewModel(id: "11"))
}
