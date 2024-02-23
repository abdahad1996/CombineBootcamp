//
//  AssertNoFailure.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 23/02/2024.
//

//You use the assertNoFailure operator to ensure there will be no errors caused by anything upstream from it. If there is, your app will then crash. This is best to use
//when developing when you need to make sure that your data is always correct and your pipeline will always work.

import SwiftUI

class AssertNoFailureVM: ObservableObject {
    @Published var dataToView: [String] = []
    
    func fetch() {
        let dataIn = ["1", "2","🧨", "3"]
        _
        = dataIn.publisher
            .tryMap { item in
                // There should never be a 🧨 in the data
                if item == "🧨" {
                    throw InvalidValueError()
                }
                return item
            }
            .assertNoFailure("This should never happen.")
            .sink { [unowned self] (item) in
                dataToView.append(item)
            }
    }
}

struct AssertNoFailure: View {
    @StateObject var vm =  AssertNoFailureVM()
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .task {
                vm.fetch()
            }
    }
}

#Preview {
    AssertNoFailure()
}
