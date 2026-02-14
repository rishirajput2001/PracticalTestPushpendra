//
//  RandomUserAPIService.swift
//  UserListDemo
//
//  Created by Mac on 14/02/26.

import Foundation

final class RandomUserAPIService {
    func fetchRandomUsers(count: Int = 1) async throws -> [RandomUserResponse] {
        var components = URLComponents(string: APIConfig.apiNinjasBaseURL + APIConfig.randomUserPath)!
        components.queryItems = [URLQueryItem(name: "count", value: "\(count)")]
        guard let url = components.url else { throw APIError.invalidURL }
        var request = URLRequest(url: url)
        request.setValue(APIConfig.apiKey, forHTTPHeaderField: "X-Api-Key")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw APIError.serverError
        }
        let decoder = JSONDecoder()
        return try decoder.decode([RandomUserResponse].self, from: data)
    }
}

enum APIError: LocalizedError {
    case invalidURL
    case serverError

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .serverError: return "Server error. Please try again."
        }
    }
}
