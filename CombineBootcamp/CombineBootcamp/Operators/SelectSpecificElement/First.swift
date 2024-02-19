//
//  First.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 18/02/2024.
//


//MARK: first
//The first operator is pretty simple. It will publish the first element that comes through the pipeline and then turn off (finish) the pipeline.

//MARK: first(where:)
//The first(where:) operator will evaluate items coming through the pipeline and see if they satisfy some condition in which you set. The first item that satisfies
//your condition will be the one that gets published and then the pipeline will finish.
                     
//MARK: tryfirst(where:)
//The tryFirst(where:) operator works just like first(where:) except it also has the ability to throw errors from the provided closure. If an error is thrown, the
//pipeline closes and finishes.
//Any try operator marks the downstream pipeline as being able to fail which means that you will have to handle potential errors in some way.

import SwiftUI
import Combine

class FirstVM: ObservableObject {
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
//            .first()
            .first { val in
                val == "Chase"
            }
            .assign(to: &$firstGuest)
    }
}

struct First: View {
    @StateObject var vm = FirstVM()
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
    First()
}
