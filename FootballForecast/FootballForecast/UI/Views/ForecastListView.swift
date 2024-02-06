//
//  ForecastListView.swift
//  FootballForecast
//
//  Created by BRIAN FALLON on 2/4/24.
//

import SwiftUI
import Kingfisher
import SwiftDate

struct ForecastListView: View {
    @Bindable var forecastItem:ForecastItem
    var selectedDate:Date

    var body: some View {
        HStack {
            Image(forecastItem.stadium.team)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 88, height: 88)

            VStack(alignment: .leading) {

                Text(forecastItem.stadium.team)
                    .font(.headline)
                    .foregroundStyle(Color("forecastBlack"))

                Text(forecastItem.stadium.name)
                    .font(.subheadline)
                    .foregroundStyle(.gray)

                HStack {
                    //Using Kingfisher to load/cache image
                    KFImage(imageURL)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)

                    Text(conditionText)
                        .font(.subheadline)
                        .foregroundStyle(Color("forecastBlack"))

                }
                .opacity(forecastItem.weather == nil ? 0 : 1)
                .overlay {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                        .padding()
                        .opacity(forecastItem.weather == nil ? 1 : 0)
                }

                HStack(spacing:2){

                    Image(systemName: "thermometer.medium")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)

                    Text(temperature)
                        .font(.caption)
                        .foregroundStyle(Color("forecastBlack"))

                    Text("|")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .padding([.leading,.trailing], 6)

                    Image(systemName: "wind")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)

                    Text(wind)
                        .font(.caption)
                        .foregroundStyle(Color("forecastBlack"))
                }
                .opacity(forecastItem.weather == nil ? 0 : 1)


                Text(roof)
                    .font(.system(size: 10, weight: .regular, design: .default))
                    .foregroundStyle(Color("forecastBlack"))
                    .padding(.top, 4)
                    .opacity(forecastItem.weather == nil ? 0 : 1)


            }
            Spacer()

        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .onAppear{

            //if the saved data is not the same as the selected day, load new weather from the API
            var shouldLoadNew = false
            if let savedDate = forecastItem.weather?.date() {

                if !isSameDay(savedDate, selectedDate) {
                    //setting weather to nil will show the progress loader
                    forecastItem.weather = nil
                    shouldLoadNew = true
                }
            } else {
                shouldLoadNew = true
            }

            if shouldLoadNew {
                let weatherService = WeatherService()
                Task {
                    let weather = await weatherService.getWeatherFor(stadium: forecastItem.stadium, date:selectedDate)
                    forecastItem.weather = weather
                }
            }

        }
    }

    var imageURL:URL? {
        //Note: URL from the API needs https added
        guard let weather = forecastItem.weather, let condition = weather.condition(), let imageURL = URL(string: condition.icon.replacingOccurrences(of: "//", with: "https://")) else {
            return nil
        }
        return imageURL
    }

    var conditionText:String {
        guard let weather = forecastItem.weather, let condition = weather.condition() else {
            return " "
        }
        return condition.text
    }

    var temperature:String {
        guard let weather = forecastItem.weather, let temperature = weather.temperature() else {
            return ""
        }
        return "\(Int(temperature))°"
    }

    var wind:String {
        guard let weather = forecastItem.weather, let wind = weather.wind() else {
            return ""
        }
        return "\(Int(wind)) mph"
    }

    var roof:String {
        var roof = ""
        if forecastItem.stadium.roof.uppercased() == "OPEN"{
            roof = forecastItem.stadium.roof.uppercased()
        } else {
            roof = "\(forecastItem.stadium.roof.uppercased()) ROOF"
        }
        return roof
    }


    //Using SwiftDate to compare dates. It's one of my favorite packages.
    func isSameDay(_ dateA: Date, _ dateB: Date) -> Bool {
        let result = dateA.compare(toDate: dateB, granularity: .day)
        if result == .orderedSame  {
            return true
        }
        return false
    }


}


#Preview {
    let stadium = Stadium(team: "Baltimore Ravens", name: "M&T Bank Stadium", location: "Baltimore, Maryland", roof: "Open")
    var previewItem = ForecastItem(stadium: stadium)

    let condition:Condition = Condition(text: "Sunny", icon: "//cdn.weatherapi.com/weather/64x64/day/113.png", code: 1000)
    let dayWeather:DayWeather = DayWeather(avgtempF: 57.8, maxwindMph: 8.8, condition: condition)
    let forecastDay:ForecastDay = ForecastDay(day: dayWeather, dateEpoch: 1707004800)
    let forecast:Forecast = Forecast(forecastday: [forecastDay])
    let weather:Weather = Weather(forecast: forecast)
    previewItem.weather = weather //comment to simulate loading

    return ForecastListView(forecastItem: previewItem, selectedDate: Date())
}
