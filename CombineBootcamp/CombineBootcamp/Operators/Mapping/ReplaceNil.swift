//
//  Map.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 18/02/2024.
//

import SwiftUI
//It’s possible you might get nils in data that you fetch. You can have Combine replace nils with a value you specify.


class ReplaceNilVM:ObservableObject{
    @Published var data = [String]()
    
    func fetch(){
        let data = ["abdul","fahad","usman",nil]
        
        data.publisher
            .replaceNil(with: "Nil values")
            .sink { [weak self] val in
                self?.data.append(val)
            }

    }
}
struct ReplaceNil: View {
    @StateObject var vm = ReplaceNilVM()
    var body: some View {
        List(vm.data, id: \.self) { datum in
            Text(datum)
        }.task {
            vm.fetch()
        }
    }
}

#Preview {
    ReplaceNil()
}
