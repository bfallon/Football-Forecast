//
//  ContentView.swift
//  FootballForecast
//
//  Created by BRIAN FALLON on 2/3/24.
//

import SwiftUI
import SwiftData

struct StadiumScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ForecastItem.stadium.team) var forecastItems: [ForecastItem]
    @State private var stadiumManager:StadiumManager = StadiumManager()
    @State private var weatherService:WeatherService = WeatherService()
    @State var selectedDate = Date()
    @State private var showingDatePicker = false
    @State private var uiID:String = UUID().uuidString

    var displayDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: selectedDate)
    }

    var body: some View {
        VStack(spacing:0){
            HStack {
                Spacer()
                    .frame(width: 44, height: 44)
                    .padding(.leading)

                Text(displayDate)
                    .font(.headline)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)

                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showingDatePicker.toggle()
                    }
                }, label: {

                    Image(systemName: "calendar")
                        .frame(width: 44, height: 44)
                        .padding(.trailing)

                })

            }

            Divider()

            ScrollView {
                ForEach(forecastItems) { item in
                    ForecastListView(forecastItem: item, selectedDate: selectedDate)
                        .padding()
                        .background(Color("forecastWhite"))
                        .cornerRadius(24)
                        .shadow(radius: 5)
                        .padding()
                        .scrollTransition { view, phase in
                            view
                                .opacity(phase.isIdentity ? 1 : 0)
                                .scaleEffect(phase.isIdentity ? 1 : 0.75)
                                .blur(radius: phase.isIdentity ? 0 : 10)

                        }
                }
                .opacity(showingDatePicker ? 0.5 : 1)
                .padding([.leading, .trailing])
            }
            .id(uiID)
            .scrollDisabled(showingDatePicker)
            .overlay(
                VStack {
                    DatePickerView(selectedDate: $selectedDate, showingDatePicker: $showingDatePicker)
                        .padding()
                        .background(Color("forecastWhite"))
                        .cornerRadius(24)
                        .padding()
                        .shadow(radius: 5)
                        .opacity(showingDatePicker ? 1 : 0)
                        .scaleEffect(showingDatePicker ? CGSize(width: 1.0, height: 1.0) : CGSize(width: 0.5, height: 0.5))

                    Spacer()

                }
            )
            .listStyle(.plain)
        }
        .onAppear {
            getStadiums()
        }
        .onChange(of: selectedDate) {
            //refresh the Scrollview id to reload the views and update the weather
            uiID = UUID().uuidString
        }

    }

    private func getStadiums() {
        //If there are no items in SwiftData (initial load), create them now...
        if forecastItems.isEmpty {
            if let stadiums = stadiumManager.getStadiums() {
                for stadium in stadiums {
                    let newItem = ForecastItem(stadium: stadium)
                    modelContext.insert(newItem)
                }
            }
        }

    }

}

#Preview {
    StadiumScreen()
        .modelContainer(for: ForecastItem.self, inMemory: true)
}
