//
//  Debounce.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 14/02/2024.
//

import SwiftUI
import Combine

//If you are getting a lot of data quickly and you don’t want SwiftUI to needlessly keep redrawing your view then the throttle operator might be just the thing you’re
//looking for.
//You can set an interval and then republish just one value out of the many you received during that interval. For example, you can set a 2-second interval. And during
//those 2 seconds, you may have received 200 values. You have the choice to republish just the most recent value received or the first value received..
import SwiftUI
import Combine

class ThrottleVM: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [String] = []

    private var cancellables = Set<AnyCancellable>()

    init() {
        // Throttle the network request based on search input
        $searchText
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .throttle(for: 10, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] searchText in
                self?.performSearch(searchText)
            }
            .store(in: &cancellables)
    }

    private func performSearch(_ searchText: String) {
        // Simulate a network request and update searchResults
        print("Searching for: \(searchText)")
        let results = (1...5).map { "Result \($0) for \(searchText)" }
        searchResults = results
    }
}

struct Throttle: View {
    @ObservedObject private var viewModel = ThrottleVM()

    var body: some View {
        VStack {
            TextField("Search", text: $viewModel.searchText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            // Display search results
            List(viewModel.searchResults, id: \.self) { result in
                Text(result)
            }
            .padding()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Throttle()
    }
}
