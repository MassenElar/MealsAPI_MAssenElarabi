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
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            content
        }
        .task {
            await viewModel.fetchMeals()
        }
    }
    
    @ViewBuilder
    var content: some View {
        VStack(spacing: 0) {
            Divider()
            List {
                ForEach(searchResult, id: \.idMeal) { meal in
                    mealRow(mealName: meal.strMeal, imageStr: meal.strMealThumb)
                        .onTapGesture {
                            viewModel.selectedRow = meal
                            self.isPresented.toggle()
                        }
                }
            }
            .navigationTitle("Desserts List")
            .searchable(text: $searchText)
            .navigationDestination(isPresented: $isPresented) {
                detailView
            }
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
    
    @ViewBuilder
    var detailView: some View {
        if let mealDetails = viewModel.selectedRow {
            MealDetailsView(viewModel: MealDetailsViewModel(id: mealDetails.idMeal))
        }
    }
    
    var searchResult: [MealDetailsModel] {
        if searchText.isEmpty {
            return viewModel.meals
        } else {
            return viewModel.meals.filter({ $0.strMeal.contains(searchText) })
        }
    }
    
}

#Preview {
    MealsListView()
}
