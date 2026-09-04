//
//  ComparisonView.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

struct ComparisonView: View {
    @State private var teamOne = UserDefaults.standard.string(forKey: "TeamOne") ?? "Tulsa"
    @State private var teamTwo = UserDefaults.standard.string(forKey: "TeamTwo") ?? "SMU"

    @State private var teamOneRankings: [String: Int] = [:]
    @State private var teamTwoRankings: [String: Int] = [:]

    @State private var presentedPicker: TeamPickerView.TeamPickerTypes?
    @State private var isShowingInfoSheet = false
    @State private var apiError = false
    @State private var sortMethod: SortMethod = .byStatAlphabetically
    @State private var swapHapticTrigger = 0

    private var sortedTeamOneRankings: [(key: String, value: Int)] {
        sortMethod.sort(teamOneRankings)
    }

    private var sortLabel: String {
        sortMethod.sectionLabel(rankingPrefix: teamOne)
    }

    var body: some View {
        NavigationStack {
            VStack {
                ComparisonHeader(
                    teamOne: teamOne,
                    teamTwo: teamTwo,
                    onChooseTeamOne: { presentedPicker = .comparisonTeamOne },
                    onChooseTeamTwo: { presentedPicker = .comparisonTeamTwo },
                    onSwap: swapTeams
                )

                ComparisonAverages(
                    teamOne: teamOne,
                    teamTwo: teamTwo,
                    teamOneRankings: teamOneRankings,
                    teamTwoRankings: teamTwoRankings
                )

                List {
                    Section("Sorted by \(sortLabel)") {
                        ForEach(sortedTeamOneRankings, id: \.key) { item in
                            ComparisonRow(
                                stat: item.key,
                                teamOneRanking: item.value,
                                teamTwoRanking: teamTwoRankings[item.key] ?? RankingsResponse.unranked
                            )
                        }
                    }

                    if apiError {
                        Text("😕 Error loading rankings. Please try again or try changing one of the teams.")
                            .foregroundStyle(.secondary)
                    }
                }
                .listStyle(.insetGrouped)
                .refreshable {
                    await refreshRankings()
                }
                .animation(.default, value: teamOneRankings)
                .animation(.default, value: sortMethod)
            }
            .padding(.top, 10)
            .navigationTitle("Compare Teams")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Info", systemImage: "info.circle") {
                        isShowingInfoSheet = true
                    }
                    .foregroundStyle(.primary)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    SortMenu(sortMethod: $sortMethod)
                        .foregroundStyle(.primary)
                }
            }
            .sheet(item: $presentedPicker) { type in
                TeamPickerView(
                    team: type == .comparisonTeamOne ? $teamOne : $teamTwo,
                    type: type
                )
            }
            .sheet(isPresented: $isShowingInfoSheet) {
                InfoView(source: .compare)
                    .presentationDetents([.medium])
            }
            .task(id: teamOne) {
                await refreshTeamOne()
            }
            .task(id: teamTwo) {
                await refreshTeamTwo()
            }
            .sensoryFeedback(.warning, trigger: swapHapticTrigger)
        }
    }

    private func swapTeams() {
        let originalOne = teamOne
        let originalOneRankings = teamOneRankings

        teamOne = teamTwo
        teamOneRankings = teamTwoRankings
        teamTwo = originalOne
        teamTwoRankings = originalOneRankings

        UserDefaults.standard.set(teamOne, forKey: "TeamOne")
        UserDefaults.standard.set(teamTwo, forKey: "TeamTwo")

        swapHapticTrigger += 1
    }

    private func refreshRankings() async {
        async let one: Void = refreshTeamOne()
        async let two: Void = refreshTeamTwo()
        _ = await (one, two)
    }

    private func refreshTeamOne() async {
        do {
            let fetched = try await TeamFetcher.getTeamRankingsFor(team: teamOne)
            guard !Task.isCancelled else { return }
            teamOneRankings = fetched.rankings
            apiError = false
        } catch is CancellationError {
            // Team changed before the fetch completed; a newer task will populate rankings.
        } catch {
            guard !Task.isCancelled else { return }
            print("Request failed with error: \(error)")
            apiError = true
        }
    }

    private func refreshTeamTwo() async {
        do {
            let fetched = try await TeamFetcher.getTeamRankingsFor(team: teamTwo)
            guard !Task.isCancelled else { return }
            teamTwoRankings = fetched.rankings
            apiError = false
        } catch is CancellationError {
            // Team changed before the fetch completed; a newer task will populate rankings.
        } catch {
            guard !Task.isCancelled else { return }
            print("Request failed with error: \(error)")
            apiError = true
        }
    }
}

#Preview {
    ComparisonView()
}
