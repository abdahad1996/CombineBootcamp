//
//  First.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 18/02/2024.
//


//MARK: last
//Use the last operator when you want to know what the last item is that comes down a pipeline.

//MARK: last(where:)
//This operator will find the last item that came through a pipeline that satisfies the criteria you provided. The last item will only be published once the pipeline has
//finished. There may be many items that satisfy your criteria but only the last one is published.
                     
//MARK: trylast(where:)
//The tryLast(where:) operator works just like last(where:) except it also has the ability to throw errors from within the closure provided. If an error is thrown,
//the pipeline closes and finishes.
//Any try operator marks the downstream pipeline as being able to fail which means that you will have to handle potential errors in some way.

import SwiftUI
import Combine

class LastVM: ObservableObject {
    @Published var firstGuest = ""
    @Published var guestList: [String] = []
    func fetch() {
        let dataIn = ["Jordan", "Chase", "Kaya", "Shai", "Novall", "Sarun"]
        _
        = dataIn.publisher
            .sink { [unowned self] (item) in
                guestList.append(item)
            }
        dataIn.publisher
//            .last()
            .last { val in
                val == "Chase"
            }
            .assign(to: &$firstGuest)
    }
}

struct Last: View {
    @StateObject var vm = LastVM()
    var body: some View {
        Text(vm.firstGuest)
            .font(.largeTitle)
        List(vm.guestList, id: \.self) { datum in
            Text(datum)
        }.task {
            vm.fetch()
        }
    }
}

#Preview {
    Last()
}
