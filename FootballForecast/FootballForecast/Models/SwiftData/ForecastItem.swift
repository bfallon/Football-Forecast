//
//  ForecastItem.swift
//  FootballForecast
//
//  Created by BRIAN FALLON on 2/3/24.
//

import Foundation
import SwiftData

@Model
final class ForecastItem {
    var stadium: Stadium
    var weather: Weather?

    init(stadium: Stadium) {
        self.stadium = stadium
    }

}

