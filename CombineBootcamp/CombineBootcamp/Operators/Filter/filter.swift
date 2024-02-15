//
//  CompactMap.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 14/02/2024.
//

import SwiftUI
import Combine

class FilteViewModel: ObservableObject {
    @Published var filteredData: [String] = []
    let dataIn = ["Person 1", "Person 2", "Animal 1", "Person 3", "Animal 2", "Animal 3"]
    private var cancellable: AnyCancellable?
    init() {
        filterData(criteria: " ")
    }
    func filterData(criteria: String) {
        filteredData = []
        cancellable = dataIn.publisher
            .filter { item -> Bool in
                item.contains(criteria)
            }.print()
            .sink { [unowned self] datum in
                filteredData.append(datum)
            }
    }
}
struct FilteView: View {
    @StateObject private var vm = FilteViewModel()
    var body: some View {
        VStack(spacing: 20) {
            
            HStack(spacing: 40.0) {
                Button("Animals") { vm.filterData(criteria: "Animal") }
                Button("People") { vm.filterData(criteria: "Person") }
                Button("All") { vm.filterData(criteria: " ") }
            }
            List(vm.filteredData, id: \.self) { datum in
                Text(datum)
            }
        }
        .font(.title)
    }}

#Preview {
    FilteView()
}
