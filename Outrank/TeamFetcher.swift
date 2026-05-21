//
//  TeamFetcher.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import Foundation

nonisolated enum TeamFetcher {
    enum TeamFetcherError: Error {
        case invalidURL
        case missingData
    }
    
    static func getTeamRankingsFor(team: String) async throws -> Team {
        print("getting rankings for \(team)")
        let endpoint = "https://tapbejtlgh.execute-api.us-east-2.amazonaws.com/dev/singleTeamQuery?team=\(team)"
        let cleanEndpoint = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let finalEndpoint = cleanEndpoint.replacing("&", with: "%26")
        print(finalEndpoint)
        
        guard let url = URL(string: finalEndpoint) else {
            throw TeamFetcherError.invalidURL
        }

        // Use the async variant of URLSession to fetch data
        // Code might suspend here
        let (data, _) = try await URLSession.shared.data(from: url)

        // Parse the JSON data
        let teamRankings = try JSONDecoder().decode(Team.self, from: data)
        return teamRankings
    }
}
