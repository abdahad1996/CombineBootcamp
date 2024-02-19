//
//  Collect.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 18/02/2024.
//

import SwiftUI
//MARK: Collect

//The collect operator won’t let items pass through the pipeline. Instead, it will put all items into an array, and then when the pipeline finishes it will publish the

//MARK: Collect  Count

//You can pass a number into the collect operator and it will keep collecting items and putting them into an array until it reaches that number and then it will publish
//the array. It will continue to do this until the pipeline finishes.


//MARK: Collect by Time or Count - View
//When using collect you can also set it with a time interval and a count. When one of these limits is reached, the items collected will be published.
class CollectVM:ObservableObject{
    @Published var dataToView: [String] = []
    func fetch(){
        let data = Array(1...25)
        data.publisher
            .map{"\($0)"}
//           .collect(5)
            .collect(.byTimeOrCount(RunLoop.main, .seconds(1), 4))
            .assign(to: &$dataToView)
    }
}
struct Collect: View {
    @StateObject var collectVM = CollectVM()
    var body: some View {
        
        List(collectVM.dataToView, id: \.self) { datum in
            Text(datum)
        }.task {
            collectVM.fetch()
        }
    }
}

#Preview {
    Collect()
}
