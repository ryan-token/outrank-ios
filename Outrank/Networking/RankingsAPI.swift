//
//  RankingsAPI.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import Foundation

/// The rankings backend. Shared by the app and the widget extension.
nonisolated enum RankingsAPI {
    enum RankingsAPIError: Error {
        case invalidURL
        case badResponse(statusCode: Int)
    }

    private static let baseURL = URL(string: "https://tapbejtlgh.execute-api.us-east-2.amazonaws.com/dev")

    /// One team's ranking in every stat.
    static func teamRankings(for team: String) async throws -> RankingsResponse {
        try await rankings(endpoint: "singleTeamQuery", queryItem: URLQueryItem(name: "team", value: team))
    }

    /// Every team's ranking in one stat.
    static func statRankings(for stat: String) async throws -> RankingsResponse {
        try await rankings(endpoint: "singleStatQuery", queryItem: URLQueryItem(name: "stat", value: stat))
    }

    // `@concurrent` so decoding runs off the caller's actor, not on the main thread.
    @concurrent
    private static func rankings(endpoint: String, queryItem: URLQueryItem) async throws -> RankingsResponse {
        // `appending(queryItems:)` percent-encodes reserved characters such as the
        // ampersand in "Texas A&M", which would otherwise split the query.
        guard let url = baseURL?.appending(path: endpoint).appending(queryItems: [queryItem]) else {
            throw RankingsAPIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        if let httpResponse = response as? HTTPURLResponse, !(200..<300).contains(httpResponse.statusCode) {
            throw RankingsAPIError.badResponse(statusCode: httpResponse.statusCode)
        }

        return try JSONDecoder().decode(RankingsResponse.self, from: data)
    }
}
