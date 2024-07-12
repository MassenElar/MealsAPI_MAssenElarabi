//
//  WebService.swift
//  MealsAPI_MassenElarabi
//
//  Created by Massen Elarabi on 7/9/24.
//

import Foundation

/// API Errors
public enum APIError: Swift.Error {
    case invalidURL
    case httpStatusCode(Int)
    case unexpectedResponse
}

// Extension for API Error

extension APIError: LocalizedError {

    public var errorDescription: String? {
        switch self {
            case .invalidURL: return "Invalid URL"
            case let .httpStatusCode(code): return "Unexpected HTTP status code: \(code)"
            case .unexpectedResponse: return "Unexpected response from the server"
        }
    }
}

// MARK: - Meals webeservice protocol

protocol MealsWebServiceProtocol {
    // Fetch Meals list
    func fetchMealsList() async throws -> MealsListModel
    // Fetch meals details
    func fetchMealDetails(id: String) async throws -> MealsListModel
}

// MARK: - Meals Web Service

public struct MealsWebService: MealsWebServiceProtocol {
    
    private let urlSession: URLSession
    private let baseURL = URL(string: "https://themealdb.com/api/json/v1/1/")!
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetchMealsList() async throws -> MealsListModel {
        guard let url = URL(string: "filter.php?c=Dessert", relativeTo: baseURL) else {
            throw APIError.invalidURL
        }
        return try await callAPI(url: url)
    }
    
    func fetchMealDetails(id: String) async throws -> MealsListModel {
        guard let url = URL(string: "lookup.php?i=" + id, relativeTo: baseURL) else {
            throw APIError.invalidURL
        }
        return try await callAPI(url: url)
    }
    
    public func callAPI<Model>(url: URL) async throws -> Model where Model: Decodable {
        let (data, response) = try await urlSession.data(from: url)
        guard let response = response as? HTTPURLResponse else {
            throw APIError.unexpectedResponse
        }
        let statusCode = response.statusCode
        guard (200...299).contains(statusCode) else {
            throw APIError.httpStatusCode(statusCode)
        }
        do {
            let decodedData = try JSONDecoder().decode(Model.self, from: data)
            return decodedData
        } catch let error {
            throw error
        }
    }
    
}
