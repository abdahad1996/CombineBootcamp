//
//  PropertyPublisher.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 20/02/2024.
//

import SwiftUI
import Combine

//You don’t always have to assemble your whole pipeline in your observable object. You can store your publishers (with or without operators) in properties or return
//publishers from functions to be used at a later time.
class PropertiesPublisherViewModel:ObservableObject{
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var team: [String] = []
    
    var firstNamePublisher = Just("Abdul")
    
    var lastNamePublisher : Just<String> {
        Just("Jamal")
            .map{$0.uppercased()}
    }
    
    

    func pipeLine() -> AnyCancellable{
        ["abdul", "ahad", "jamal"].publisher
        .map {
         $0.lowercased()
        }
        .sink { [unowned self] name in
        team.append(name)
        }
    }
    
    func fetch(){
        firstNamePublisher.assign(to: &$firstName)
        
        lastNamePublisher.assign(to: &$lastName)

        
        let _ = pipeLine()

    }
    
    
}
struct PropertyPublisher: View {
    @StateObject var vm = PropertiesPublisherViewModel()
    var body: some View {
        VStack {
          
        
            
            return List {
                Section(header: Text("Header").bold().font(.title), footer: Text("Footer").font(.footnote)) {
                    ForEach(vm.team, id: \.self) { datum in
                        Text(datum)
                    }
                }
            }
        }
        
    }
}

#Preview {
    PropertyPublisher()
}
