//
//  Conversions.swift
//  Outrank
//
//  Created by Ryan Token on 10/20/21.
//

import Foundation

nonisolated enum Conversions {
    static func getHumanReadableStat(for stat: String) -> String {
        if stat != "DefensiveTDs" {
            let cleanStat = stat.camelCaseToWords()
            return cleanStat
        } else {
            return "Defensive TDs"
        }
    }
    
    static func getHumanReadableRanking(for ranking: Int) -> String {
        if ranking == 99999 { return "Unknown" }

        // Teens always take "th" (11th, 12th, 13th, 111th, ...).
        let lastTwo = ranking % 100
        if (11...13).contains(lastTwo) { return "\(ranking)th" }

        switch ranking % 10 {
        case 1: return "\(ranking)st"
        case 2: return "\(ranking)nd"
        case 3: return "\(ranking)rd"
        default: return "\(ranking)th"
        }
    }
    
    static func getHumanReadableTeam(from team: String) -> String {
        switch team {
        case "AirForce":
          return "Air Force"
        case "Akron":
          return "Akron"
        case "Alabama":
          return "Alabama"
        case "AppState":
          return "App State"
        case "Arizona":
          return "Arizona"
        case "ArizonaSt":
          return "Arizona St."
        case "Arkansas":
          return "Arkansas"
        case "ArkansasSt":
          return "Arkansas St."
        case "ArmyWestPoint":
          return "Army West Point"
        case "Auburn":
          return "Auburn"
        case "BallSt":
          return "Ball St."
        case "Baylor":
          return "Baylor"
        case "BoiseSt":
          return "Boise St."
        case "BostonCollege":
          return "Boston College"
        case "BowlingGreen":
          return "Bowling Green"
        case "Buffalo":
          return "Buffalo"
        case "BYU":
          return "BYU"
        case "California":
          return "California"
        case "CentralMich":
          return "Central Mich."
        case "Charlotte":
          return "Charlotte"
        case "Cincinnati":
          return "Cincinnati"
        case "Clemson":
          return "Clemson"
        case "CoastalCarolina":
          return "Coastal Carolina"
        case "Colorado":
          return "Colorado"
        case "ColoradoSt":
          return "Colorado St."
        case "Duke":
          return "Duke"
        case "EastCarolina":
          return "East Carolina"
        case "EasternMich":
          return "Eastern Mich."
        case "FIU":
          return "FIU"
        case "FlaAtlantic":
          return "Fla. Atlantic"
        case "Florida":
          return "Florida"
        case "FloridaSt":
          return "Florida St."
        case "FresnoSt":
          return "Fresno St."
        case "GaSouthern":
          return "Ga. Southern"
        case "Georgia":
          return "Georgia"
        case "GeorgiaSt":
          return "Georgia St."
        case "GeorgiaTech":
          return "Georgia Tech"
        case "Hawaii":
          return "Hawaii"
        case "Houston":
          return "Houston"
        case "Illinois":
          return "Illinois"
        case "Indiana":
          return "Indiana"
        case "Iowa":
          return "Iowa"
        case "IowaSt":
          return "Iowa St."
        case "JacksonvilleSt":
          return "Jacksonville St."
        case "JamesMadison":
          return "James Madison"
        case "Kansas":
          return "Kansas"
        case "KansasSt":
          return "Kansas St."
        case "KentSt":
          return "Kent St."
        case "Kentucky":
          return "Kentucky"
        case "Liberty":
          return "Liberty"
        case "Louisiana":
          return "Louisiana"
        case "LouisianaTech":
          return "Louisiana Tech"
        case "Louisville":
          return "Louisville"
        case "LSU":
          return "LSU"
        case "Marshall":
          return "Marshall"
        case "Maryland":
          return "Maryland"
        case "Massachusetts":
          return "Massachusetts"
        case "Memphis":
          return "Memphis"
        case "MiamiFL":
          return "Miami (FL)"
        case "MiamiOH":
          return "Miami (OH)"
        case "Michigan":
          return "Michigan"
        case "MichiganSt":
          return "Michigan St."
        case "MiddleTenn":
          return "Middle Tenn."
        case "Minnesota":
          return "Minnesota"
        case "MississippiSt":
          return "Mississippi St."
        case "Missouri":
          return "Missouri"
        case "Navy":
          return "Navy"
        case "NCState":
          return "NC State"
        case "Nebraska":
          return "Nebraska"
        case "Nevada":
          return "Nevada"
        case "NewMexico":
          return "New Mexico"
        case "NewMexicoSt":
          return "New Mexico St."
        case "NorthCarolina":
          return "North Carolina"
        case "NorthTexas":
          return "North Texas"
        case "NorthernIll":
          return "Northern Ill."
        case "Northwestern":
          return "Northwestern"
        case "NotreDame":
          return "Notre Dame"
        case "Ohio":
          return "Ohio"
        case "OhioSt":
          return "Ohio St."
        case "Oklahoma":
          return "Oklahoma"
        case "OklahomaSt":
          return "Oklahoma St."
        case "OldDominion":
          return "Old Dominion"
        case "OleMiss":
          return "Ole Miss"
        case "Oregon":
          return "Oregon"
        case "OregonSt":
          return "Oregon St."
        case "PennSt":
          return "Penn St."
        case "Pittsburgh":
          return "Pittsburgh"
        case "Purdue":
          return "Purdue"
        case "Rice":
          return "Rice"
        case "Rutgers":
          return "Rutgers"
        case "SamHouston":
            return "Sam Houston"
        case "SMU":
          return "SMU"
        case "SanDiegoSt":
          return "San Diego St."
        case "SanJoseSt":
          return "San Jose St."
        case "SouthAlabama":
          return "South Alabama"
        case "SouthCarolina":
          return "South Carolina"
        case "SouthFla":
          return "South Fla."
        case "SouthernCalifornia":
          return "Southern California"
        case "SouthernMiss":
          return "Southern Miss."
        case "Stanford":
          return "Stanford"
        case "Syracuse":
          return "Syracuse"
        case "TCU":
          return "TCU"
        case "Temple":
          return "Temple"
        case "Tennessee":
          return "Tennessee"
        case "Texas":
          return "Texas"
        case "TexasAM":
          return "Texas A&M"
        case "TexasSt":
          return "Texas St."
        case "TexasTech":
          return "Texas Tech"
        case "Toledo":
          return "Toledo"
        case "Tulane":
          return "Tulane"
        case "Tulsa":
          return "Tulsa"
        case "Troy":
          return "Troy"
        case "UAB":
          return "UAB"
        case "UCF":
          return "UCF"
        case "UCLA":
          return "UCLA"
        case "UConn":
          return "UConn"
        case "ULM":
          return "ULM"
        case "UNLV":
          return "UNLV"
        case "UTEP":
          return "UTEP"
        case "UTSA":
          return "UTSA"
        case "Utah":
          return "Utah"
        case "UtahSt":
          return "Utah St."
        case "Vanderbilt":
          return "Vanderbilt"
        case "Virginia":
          return "Virginia"
        case "VirginiaTech":
          return "Virginia Tech"
        case "Washington":
          return "Washington"
        case "WashingtonSt":
          return "Washington St."
        case "WakeForest":
          return "Wake Forest"
        case "WestVirginia":
          return "West Virginia"
        case "WesternKy":
          return "Western Ky."
        case "WesternMich":
          return "Western Mich."
        case "Wisconsin":
          return "Wisconsin"
        case "Wyoming":
          return "Wyoming"
        default:
            return "Unknown"
        }
    }
}
