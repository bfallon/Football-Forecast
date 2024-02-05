//
//  WeatherService.swift
//  FootballForecast
//
//  Created by BRIAN FALLON on 2/3/24.
//

import Foundation
import SwiftUI

class WeatherService: ObservableObject {

    private let apiKey = "43d21dda3a9844d391a204425240302"
    private let baseUrl = "https://api.weatherapi.com/v1/forecast.json"

    //todo return this as an item to insert into data
    func getWeatherFor(stadium:Stadium, date:Date) async -> Weather? {

        //the api requires an hour, we set 1PM, but this data is not used. We are providing the average weather for the day. In the future we can add a time value for day/night game.
        let hour = 13

        let endpoint = "\(baseUrl)?key=\(apiKey)&q=\(stadium.location)&unixdt=\(Int(date.timeIntervalSince1970))&hour=\(hour)"

        guard let encodedEndpoint = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Cannot encode endpoint")
            return nil
        }

        guard let url = URL(string: encodedEndpoint) else {
            print("Cannot convert URL \(baseUrl)")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            //uncomment to see payload from API
//            let str = String(decoding: data, as: UTF8.self)
//            print("RAW JSON STR \(str)")
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

            guard let weather = try? jsonDecoder.decode(Weather.self, from: data) else {
                print("Cannot decode JSON to Weather")
                return nil
            }

            return weather

        } catch {
            return nil
        }
    }


}
