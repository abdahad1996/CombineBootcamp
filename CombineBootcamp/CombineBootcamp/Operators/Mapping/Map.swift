//
//  Map.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 18/02/2024.
//

import SwiftUI
//With the map operator, you provide the code to perform on each item coming through the pipeline. With the map function, you can inspect items coming through and
//validate them, update them to something else, even change the type of the item.
//Maybe your map operator receives a tuple (a type that holds two values) but you only want one value out of it to continue down the pipeline. Maybe it receives Ints
//but you want to convert them to Strings. This is an operator in which you can do anything you want within it. This makes it a very popular operator to know.

class MapVM:ObservableObject{
    @Published var data = [String]()
    
    func fetch(){
        let data = ["abdul","fahad","usman"]
        
        data.publisher.map { val in
            val.uppercased()
        }.sink { [weak self] val in
            self?.data.append(val)
        }
    }
}
struct Map: View {
    @StateObject var vm = MapVM()
    var body: some View {
        List(vm.data, id: \.self) { datum in
            Text(datum)
        }.task {
            vm.fetch()
        }
    }
}

#Preview {
    Map()
}
