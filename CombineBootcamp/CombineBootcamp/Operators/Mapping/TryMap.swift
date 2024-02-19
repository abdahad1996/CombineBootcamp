//
//  Map.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 18/02/2024.
//

import SwiftUI
//The tryMap operator is just like the map operator except it can throw errors. Use this if you believe items coming through could possibly cause an error. Errors
//thrown will finish the pipeline early.

struct TryMapError: Error, Identifiable, CustomStringConvertible {
let id = UUID()
let description = "There was a an error while retrieving values."
}
class TryMapVM:ObservableObject{
    @Published var data = [String]()
    @Published var error: TryMapError?
    
    func fetch(){
        let data = ["abdul","fahad","usman","Error"]
        
        data.publisher
            .tryMap{ val in
            if val.contains("Error") {
                throw TryMapError()
            }
            return val.uppercased()
        }
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error as? TryMapError
                }
            } receiveValue: { [weak self] val in
                self?.data.append(val)
            }

    }
}
struct TryMap: View {
    @StateObject var vm = TryMapVM()
    var body: some View {
        List(vm.data, id: \.self) { datum in
            Text(datum)
        }.task {
            vm.fetch()
        }.alert(item: $vm.error) { error in
            Alert(title: Text("Error"), message: Text(error.description))
            }
    }
}

#Preview {
    TryMap()
}
