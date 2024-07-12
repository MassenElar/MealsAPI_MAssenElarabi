//
//  MealsListView.swift
//  MealsAPI_MassenElarabi
//
//  Created by Massen Elarabi on 7/9/24.
//

import SwiftUI

struct MealsListView: View {
    
    @ObservedObject var viewModel = MealsListViewModel()
    @State var isPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            content
        }
    }
    
    @ViewBuilder
    var content: some View {
        VStack(spacing: 0) {
            Text("Dessert List")
                .font(.largeTitle)
                .foregroundStyle(.blue)
                .padding()
            Divider()
            List {
                ForEach(viewModel.meals, id: \.idMeal) { meal in
                    mealRow(mealName: meal.strMeal, imageStr: meal.strMealThumb)
                        .onTapGesture {
                            viewModel.selectedRow = meal
                            self.isPresented.toggle()
                        }
                }
            }
            .navigationDestination(isPresented: $isPresented) {
                detailView
            }
        }
        .task {
            await viewModel.fetchMeals()
        }
    }
    
    @ViewBuilder
    var detailView: some View {
        if let mealDetails = viewModel.selectedRow {
            MealDetailsView(viewModel: MealDetailsViewModel(id: mealDetails.idMeal))
        }
    }
    
    func mealRow(mealName: String, imageStr: String) -> some View {
        HStack {
            Text(mealName)
                .font(.headline)
            Spacer()
            AsyncImage(url: URL(string: imageStr)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 60, height: 60)
            .clipShape(.rect(cornerRadius: 10))
            Image(systemName: "chevron.right")
                .foregroundStyle(.blue)
        }
    }
}

#Preview {
    MealsListView()
}
