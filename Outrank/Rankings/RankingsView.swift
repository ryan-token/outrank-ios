//
//  RankingsView.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

struct RankingsView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.requestReview) private var requestReview
    @AppStorage("AppUsedCount") private var appUsedCount = 0

    @State private var currentTeam = UserDefaults.standard.string(forKey: "CurrentTeam") ?? "Air Force"
    @State private var teamRankings: [String: Int] = [:]
    @State private var apiError = false
    @State private var selectedStat: String?

    // Owned here rather than by RankingsSidebar. The sidebar sits inside both branches of
    // the size-class check below, and those are two distinct positions in the view tree:
    // flipping between them (rotating an iPad, resizing a Stage Manager window) tears the
    // sidebar down and takes any state it owned with it.
    @State private var sortMethod: SortMethod = .byStatAlphabetically
    @State private var isShowingTeamPicker = false
    @State private var isShowingInfoSheet = false

    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                NavigationSplitView {
                    RankingsSidebar(
                        isInSplitView: true,
                        currentTeam: currentTeam,
                        teamRankings: teamRankings,
                        apiError: apiError,
                        selectedStat: $selectedStat,
                        sortMethod: $sortMethod,
                        isShowingTeamPicker: $isShowingTeamPicker,
                        isShowingInfoSheet: $isShowingInfoSheet,
                        refresh: refreshRankings
                    )
                } detail: {
                    RankingsDetail(
                        team: currentTeam,
                        teamRankings: teamRankings,
                        selectedStat: selectedStat
                    )
                }
            } else {
                NavigationStack {
                    RankingsSidebar(
                        isInSplitView: false,
                        currentTeam: currentTeam,
                        teamRankings: teamRankings,
                        apiError: apiError,
                        selectedStat: $selectedStat,
                        sortMethod: $sortMethod,
                        isShowingTeamPicker: $isShowingTeamPicker,
                        isShowingInfoSheet: $isShowingInfoSheet,
                        refresh: refreshRankings
                    )
                    .navigationDestination(for: String.self) { stat in
                        RankingDetailView(
                            team: currentTeam,
                            stat: stat,
                            ranking: teamRankings[stat] ?? RankingsResponse.unranked
                        )
                    }
                }
            }
        }
        .tint(.primary)
        // Presented from out here so an open sheet survives a size-class change too.
        .sheet(isPresented: $isShowingTeamPicker) {
            TeamPickerView(team: $currentTeam, type: .rankings)
        }
        .sheet(isPresented: $isShowingInfoSheet) {
            InfoView(source: .rankings)
                .presentationDetents([.medium])
        }
        .task(id: currentTeam) {
            await refreshRankings()
        }
        .onAppear {
            appUsedCount += 1
        }
    }

    private func refreshRankings() async {
        do {
            let fetched = try await TeamFetcher.getTeamRankingsFor(team: currentTeam)
            guard !Task.isCancelled else { return }
            teamRankings = fetched.rankings
            apiError = false
            if appUsedCount > 5 {
                requestReview()
            }
        } catch is CancellationError {
            // Team changed before this fetch completed; the newer task will populate rankings.
        } catch {
            guard !Task.isCancelled else { return }
            print("Request failed with error: \(error)")
            apiError = true
        }
    }
}

private struct RankingsSidebar: View {
    let isInSplitView: Bool
    let currentTeam: String
    let teamRankings: [String: Int]
    let apiError: Bool
    @Binding var selectedStat: String?
    @Binding var sortMethod: SortMethod
    @Binding var isShowingTeamPicker: Bool
    @Binding var isShowingInfoSheet: Bool
    let refresh: () async -> Void

    var body: some View {
        Group {
            if isInSplitView {
                List(selection: $selectedStat) {
                    RankingsSection(
                        currentTeam: currentTeam,
                        teamRankings: teamRankings,
                        apiError: apiError,
                        sortMethod: sortMethod
                    )
                }
            } else {
                List {
                    RankingsSection(
                        currentTeam: currentTeam,
                        teamRankings: teamRankings,
                        apiError: apiError,
                        sortMethod: sortMethod
                    )
                }
            }
        }
        .refreshable {
            await refresh()
        }
        .animation(.default, value: teamRankings)
        .animation(.default, value: sortMethod)
        .navigationTitle(currentTeam)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Choose Team") {
                    isShowingTeamPicker = true
                }
                .foregroundStyle(.primary)
            }

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
    }
}

private struct RankingsSection: View {
    let currentTeam: String
    let teamRankings: [String: Int]
    let apiError: Bool
    let sortMethod: SortMethod

    private var sortedRankings: [(key: String, value: Int)] {
        sortMethod.sort(teamRankings)
    }

    var body: some View {
        Section("Sorted by \(sortMethod.sectionLabel())") {
            ForEach(sortedRankings, id: \.key) { item in
                NavigationLink(value: item.key) {
                    RankingRow(stat: item.key, ranking: item.value)
                }
            }

            if apiError {
                Text("😕 Error loading rankings for \(currentTeam). Please try again or try a different team.")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct RankingsDetail: View {
    let team: String
    let teamRankings: [String: Int]
    let selectedStat: String?

    var body: some View {
        if let selectedStat {
            RankingDetailView(
                team: team,
                stat: selectedStat,
                ranking: teamRankings[selectedStat] ?? RankingsResponse.unranked
            )
            .id(selectedStat)
        } else {
            WelcomeView(type: .rankings)
        }
    }
}

private struct RankingRow: View {
    let stat: String
    let ranking: Int

    var body: some View {
        HStack(spacing: 8) {
            Text(Conversions.getHumanReadableStat(for: stat))
                .font(.headline)

            Spacer()

            Text(Conversions.getHumanReadableRanking(for: ranking))
                .foregroundStyle(RankingStyle.color(for: ranking))
        }
    }
}

#Preview {
    RankingsView()
        .environment(TabController())
}
