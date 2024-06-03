
import Foundation
import SwiftData

struct FootprintAchievement {
    let conditions: [(Double, Int) -> Bool]
    let description: String

    func evaluate(footprint: Double, daysLogged: Int) -> Bool {
        for condition in conditions {
            if !condition(footprint, daysLogged) {
                return false
            }
        }
        return true
    }
}

struct LoggingAchievement {
    let condition: (Int) -> Bool
    let description: String
}

let footprintachievements: [FootprintAchievement] = [
    FootprintAchievement(conditions:  [ { footprint, _ in footprint < 200 } ]
                         , description: "You got a footprint under 200 lbs/CO2! Great job!"),
    FootprintAchievement(conditions: [ { footprint, _ in footprint < 100 } ], description: "You got a footprint under 100 lbs/CO2! Fantastic!"),
    FootprintAchievement(conditions: [
        { footprint, daysLogged in footprint < 200 && daysLogged >= 7 }
    ], description: "You got an average footprint under 200 lbs/CO2 for at least 7 days! Incredible!"),
    FootprintAchievement(conditions: [
        { footprint, daysLogged in footprint < 100 && daysLogged >= 7 }
    ], description: "You got an average footprint under 100 lbs/CO2 for at least 7 dats! Fantastic!"),
    FootprintAchievement(conditions: [
        { footprint, daysLogged in footprint < 200 && daysLogged >= 30 }
    ], description: "You got an average footprint under 200 lbs/CO2 for at least 30 days! Consistency!"),
    FootprintAchievement(conditions: [
        { footprint, daysLogged in footprint < 100 && daysLogged >= 30 }
    ], description: "You got an average footprint under 100 lbs/CO2 for at least 30 days! You're awesome!"),
    FootprintAchievement(conditions: [
        { footprint, _ in footprint < 50 }
    ], description: "You got a footprint under 50 lbs/CO2! You're an amazing environmentalist!")
]


let loggingachievements: [LoggingAchievement] = [
    LoggingAchievement(condition: { $0 >= 1}, description: "You made your first log! Congrats!"),
    LoggingAchievement(condition: { $0 >= 7}, description: "You've logged 7 times! Amazing!"),
    LoggingAchievement(condition: { $0 >= 30}, description: "You've logged 30 times! You love the Earth!"),
]

func applyFootprintAchievements(log: LogViewModel, user: User) -> Set<String> {
    var achievedDescriptions: Set<String> = Set()

    for achievement in footprintachievements {
        if achievement.evaluate(footprint: log.footprint, daysLogged: user.logs.count) {
            achievedDescriptions.insert(achievement.description)
        }
    }
    return achievedDescriptions
}

func applyLoggingAchievements(user: User) -> Set<String> {
    var achievedDescriptions: Set<String> = Set()
    
    let logsCount = user.logs.count
    
    for achievement in loggingachievements {
        if achievement.condition(logsCount) {
            achievedDescriptions.insert(achievement.description)
        }
    }
    return achievedDescriptions
}

