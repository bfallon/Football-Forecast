//
//  DatePickerView.swift
//  FootballForecast
//
//  Created by BRIAN FALLON on 2/4/24.
//

import SwiftUI
import SwiftDate

struct DatePickerView: View {

    @Binding var selectedDate:Date
    @Binding var showingDatePicker:Bool

    var endDate:Date {
        return Date() + 7.days
    }

    var body: some View {
        DatePicker(
            "Select Date",
            selection: $selectedDate,
            in: Date()...endDate,
            displayedComponents: [.date]
        )

        .datePickerStyle(.graphical)
        .onChange(of: selectedDate) {
            withAnimation(.easeInOut(duration: 0.2)) {
                showingDatePicker.toggle()
            }
        }
    }
}

#Preview {
    DatePickerView(selectedDate: .constant(Date()), showingDatePicker: .constant(true))
}
