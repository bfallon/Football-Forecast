//
//  StadiumManager.swift
//  FootballForecast
//
//  Created by BRIAN FALLON on 2/3/24.
//

import Foundation
import SwiftData

class StadiumManager:ObservableObject {

    let jsonPath = "stadiums.json"

    func getStadiums() -> [Stadium]? {
        //See if there are stadiums saved, if not load from the local JSON

        // Get the URL of the JSON file in the main bundle
        guard let url = Bundle.main.url(forResource: jsonPath, withExtension: nil) else {
            print("JSON file not found.")
            return nil
        }

        do {
            // Read the contents of the JSON file into a Data object
            let data = try Data(contentsOf: url)

            // Parse the JSON data
            let jsonDecoder = JSONDecoder()

            guard let stadiums = try? jsonDecoder.decode([Stadium].self, from: data) else {
                print("Cannot decode JSON to Stadium")
                return nil
            }
            return stadiums

        } catch {
            print("Error loading JSON: \(error.localizedDescription)")
        }

        return nil
    }

}

