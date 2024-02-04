//
//  Weather.swift
//  FootballForecast
//
//  Created by BRIAN FALLON on 2/4/24.
//

import Foundation

//The information we want in nested deep in the JSON payload. Create the all the structs and a top-level helper to get the info
struct Weather: Codable {
    var forecast:Forecast?

    //MARK: - helpers to get info for UI
    func condition() -> Condition? {
        return forecast?.forecastday.first?.day.condition
    }

    func temperature() -> Double? {
        return forecast?.forecastday.first?.day.avgtempF
    }

    func wind() -> Double? {
        return forecast?.forecastday.first?.day.maxwindMph
    }

    func date() -> Date? {
        guard let epoch = forecast?.forecastday.first?.dateEpoch else {
            return nil
        }
        return Date(timeIntervalSince1970: epoch)
    }

}

struct Forecast: Codable {
    var forecastday:[ForecastDay]
}

struct ForecastDay: Codable {
    var day:DayWeather
    var dateEpoch:TimeInterval?
}

struct DayWeather: Codable {
    var avgtempF:Double
    var maxwindMph:Double
    var condition:Condition

}

struct Condition: Codable {
    var text:String
    var icon:String
    var code:Int


}
