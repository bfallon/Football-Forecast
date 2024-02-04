//
//  FootballForecastTests.swift
//  FootballForecastTests
//
//  Created by BRIAN FALLON on 2/3/24.
//

import XCTest
@testable import FootballForecast

final class FootballForecastTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    //Mark: - Test local JSON
    func testLoadLocalJSON() throws {
        let stadiums = StadiumManager().getStadiums()
        //stadiums cannot be nil
        XCTAssertNotNil(stadiums, "Local JSON is nil")
        //stadiums must contain 32 items (one for each NFL team)
        XCTAssertEqual(stadiums?.count, 32)

    }

    func testLoadLocalJSONPerfomance() throws {
        // Measure how fast the stadiums are parsed
        self.measure {
            let _ = StadiumManager().getStadiums()
        }
    }

    //Mark: - Test API
    //cannot wrap testing code in a 'Task' so run this on the main thread
    @MainActor
    func testWeatherAPI() async throws {
        let stadium = Stadium(team: "Baltimore Ravens", name: "M&T Bank Stadium", location: "Baltimore, Maryland", roof: "Open")

        let weatherResult = await WeatherService().getWeatherFor(stadium: stadium, date: Date())

        //weatherResult cannot be nil
        XCTAssertNotNil(weatherResult, "API result is nil")
        //Weather must have the condition
        XCTAssertNotNil(weatherResult?.condition(), "Weather condition is nil")


        //Weather must have the temperature
        XCTAssertNotNil(weatherResult?.temperature(), "Weather temperature is nil")

        //Weather must have the wind
        XCTAssertNotNil(weatherResult?.wind(), "Weather wind is nil")

        //Weather must have the date
        XCTAssertNotNil(weatherResult?.date(), "Weather wind is nil")

    }
}
