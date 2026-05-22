//
//  Team.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import Foundation

nonisolated struct Team: Codable, Loopable {
    var BlockedKicks: Int
    var FewestPenaltiesPerGame: Int
    var FourthDownConversionPctDefense: Int
    var TotalDefense: Int
    var TacklesForLossAllowed: Int
    var KickoffReturnDefense: Int
    var RedZoneOffense: Int
    var TeamSacks: Int
    var BlockedPunts: Int
    var PassesIntercepted: Int
    var PassingYardsAllowed: Int
    var ThirdDownConversionPct: Int
    var KickoffReturns: Int
    var FewestPenaltyYardsPerGame: Int
    var RushingOffense: Int
    var PassesHadIntercepted: Int
    var FirstDownsOffense: Int
    var TimeOfPossession: Int
    var PuntReturns: Int
    var BlockedKicksAllowed: Int
    var FewestPenalties: Int
    var FumblesRecovered: Int
    var BlockedPuntsAllowed: Int
    var RedZoneDefense: Int
    var PuntReturnDefense: Int
    var TurnoversLost: Int
    var NetPunting: Int
    var FewestPenaltyYards: Int
    var TurnoverMargin: Int
    var FirstDownsDefense: Int
    var TeamTacklesForLoss: Int
    var RushingDefense: Int
    var SacksAllowed: Int
    var TeamPassingEfficiency: Int
    var WinningPercentage: Int
    var DefensiveTDs: Int
    var FourthDownConversionPct: Int
    var ScoringDefense: Int
    var ScoringOffense: Int
    var FumblesLost: Int
    var TeamPassingEfficiencyDefense: Int
    var CompletionPercentage: Int
    var TotalOffense: Int
    var PassingYardsPerCompletion: Int
    var PassingOffense: Int
    var ThirdDownConversionPctDefense: Int
    var TurnoversGained: Int
    
    static let exampleTeam = Team(BlockedKicks: 99999, FewestPenaltiesPerGame: 99999, FourthDownConversionPctDefense: 99999, TotalDefense: 99999, TacklesForLossAllowed: 99999, KickoffReturnDefense: 99999, RedZoneOffense: 99999, TeamSacks: 99999, BlockedPunts: 99999, PassesIntercepted: 99999, PassingYardsAllowed: 99999, ThirdDownConversionPct: 99999, KickoffReturns: 99999, FewestPenaltyYardsPerGame: 99999, RushingOffense: 99999, PassesHadIntercepted: 99999, FirstDownsOffense: 99999, TimeOfPossession: 99999, PuntReturns: 99999, BlockedKicksAllowed: 99999, FewestPenalties: 99999, FumblesRecovered: 99999, BlockedPuntsAllowed: 99999, RedZoneDefense: 99999, PuntReturnDefense: 99999, TurnoversLost: 99999, NetPunting: 99999, FewestPenaltyYards: 99999, TurnoverMargin: 99999, FirstDownsDefense: 99999, TeamTacklesForLoss: 99999, RushingDefense: 99999, SacksAllowed: 99999, TeamPassingEfficiency: 99999, WinningPercentage: 99999, DefensiveTDs: 99999, FourthDownConversionPct: 99999, ScoringDefense: 99999, ScoringOffense: 99999, FumblesLost: 99999, TeamPassingEfficiencyDefense: 99999, CompletionPercentage: 99999, TotalOffense: 99999, PassingYardsPerCompletion: 99999, PassingOffense: 99999, ThirdDownConversionPctDefense: 99999, TurnoversGained: 99999)
}
