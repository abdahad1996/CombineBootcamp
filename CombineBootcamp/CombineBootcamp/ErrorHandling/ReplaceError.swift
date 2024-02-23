//
//  ReplaceError.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 23/02/2024.
//

import SwiftUI
import Combine

//Instead of showing an alert on the UI, you could use the replaceError operator to substitute a value instead. If you have a pipeline that sends integers down the
//pipeline and there’s an operator that throws an error, then you can use replaceError to replace the error with a zero, for example.
class ReplaceErrorVM: ObservableObject {
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
            .replaceError(with: "replace error")
//            .catch{ err in
//                Just("error in pipeline hence stop here")
//            }
            .sink { [unowned self] (item) in
                dataToView.append(item)
            }
    }
}

struct ReplaceError: View {
    @StateObject var vm = ReplaceErrorVM()
    var body: some View {

        List(vm.dataToView, id: \.self) { datum in
            Text(datum)
        }.task {
            vm.fetch()
        }
    }
}

 

#Preview {
    ReplaceError()
}
