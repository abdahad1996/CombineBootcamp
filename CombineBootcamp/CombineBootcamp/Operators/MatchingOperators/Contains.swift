//
//  Contains.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 26/01/2024.
//

import Foundation
import Combine
import SwiftUI

//The contains operator has just one purpose - to let you know if an item coming through your pipeline matches the criteria you specify.

//It will publish a true when a
//match is found and then finishes the pipeline, meaning it stops the flow of any remaining data.

//If no values match the criteria then a false is published and the pipeline finishes/closes.
class ContainsViewModel: ObservableObject {
    @Published var description = ""
    @Published var airconditioning = false
    @Published var heating = false
    @Published var basement = false
    @Published var error = ""
    private var cancellables: [AnyCancellable] = []
    func fetch() {
        let incomingData = ["3 bedrooms", "2 bathrooms", "Air conditioning", "Basementss"]
       
        
        incomingData.publisher
        .prefix(2)
        .sink { [unowned self] (item) in
        description += item + "\n"
        }
        
        .store(in: &cancellables)
            
        //end after finidng condition with true or false
        incomingData.publisher
        .contains("Air conditioning")
        .print()
        .assign(to: &$airconditioning)
            
        incomingData.publisher
        .contains("Heating")
        .assign(to: &$heating)
            
        
        //end after finidng condition with true or throw error
        incomingData.publisher
            .tryContains(where: { basement in
                if basement != "basement" {
                    throw NSError()
                }else{
                    return true
                }
               
            })
            .sink { completion in
                if case .failure(let error) = completion {
                    self.error = "error in basement"
                }
            } receiveValue: {[weak self] value in
                self?.basement = value
            }.store(in: &cancellables)

    }
}
// MARK: CONTAINS(WHERE:)
//This contains(where:) operator gives you a closure to specify your criteria to find a match. This could be useful where the items coming through the pipeline are
//not simple primitive types like a String or Int. Items that do not match the criteria are dropped (not published) and when the first item is a match, the boolean true is
//published.
//When the first match is found, the pipeline is finished/stopped.
//If no matches are found at the end of all the items, a boolean false is published and the pipeline is finished/stopped.

// MARK: TRYContain(WHERE:)
//You have the option to look for items in your pipeline and publish a true for the criteria you specify or publish an error for the condition you set.
//When an item matching your condition is found, a true will then be published and the pipeline will be finished/closed.
//Alternatively, you can throw an error that will pass the error downstream and complete the pipeline with a failure. The subscriber will ultimately receive a true,
//false, or error and finish.

struct ContainsView:View {
    @StateObject var vm = ContainsViewModel()
    var body: some View {
        Group{
            Text(vm.description)
            Toggle("Air conditioning", isOn: $vm.airconditioning)
            Toggle("basement", isOn: $vm.basement)
            if (vm.error.count > 0) {
                Text(vm.error).foregroundStyle(.red).padding()
            }
            Toggle("heating", isOn: $vm.heating)

            

        }.padding()
            .onAppear{
                vm.fetch()
            }
    }
}
#Preview {
    ContainsView()
}
