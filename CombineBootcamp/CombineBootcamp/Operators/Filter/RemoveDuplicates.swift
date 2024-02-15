//
//  CompactMap.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 14/02/2024.
//

import SwiftUI
import Combine

///our app may subscribe to a feed of data that could give you repeated values. Imagine a weather app for example that periodically checks the temperature. If your
//app keeps getting the same temperature then there may be no need to send it through the pipeline and update the UI.
//                                                                      The removeDuplicates could be a solution so your app only responds to data that has changed rather than getting duplicate data. If the data being sent through
//                                                                        the pipeline conforms to the Equatable protocol then this operator will do all the work of removing duplicates for you


class RemoveDuplicatesVM:ObservableObject {
    @Published var data: [String] = []
    
    func fetch() {
        let dataIn = ["Value 1","Value 1", "Value 3", "Value 5"]
        
        _ = dataIn.publisher
            .removeDuplicates()
            .print()
            .sink(receiveValue: { [weak self] value in
                self?.data.append(value)
            })
        
    }
}
struct RemoveDuplicates: View {
    @StateObject var vm = RemoveDuplicatesVM()
    var body: some View {

        List(vm.data, id: \.self) { datum in
            Text(datum)
        }.task {
            vm.fetch()
        }
        
    }
}

#Preview {
    RemoveDuplicates()
}
