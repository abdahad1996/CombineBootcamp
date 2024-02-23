//
//  CombineLatest.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 22/02/2024.
//

import SwiftUI

//Using the combineLastest operator you can connect two or more pipelines and then use a closure to process the latest data received from each publisher in some
//way. There is also a combineLatest to connect 3 or even 4 pipelines together. You will still have just one pipeline after connecting all of the publishers

//The combineLatest receives the latest values from both
//pipelines in the form of a Tuple.

//There are two publishers with many artists and many colors. But
//the combineLatest is only interested in the LATEST (or sometimes
//last) item each pipeline publishes.

//The combineLatest is only
//interested in the latest value the publisher sends down
//the pipeline.
private struct PlayerData: Identifiable {
    let id = UUID()
    var name = ""
    var number = 0
}

class CombineLatestVM: ObservableObject {
    @Published fileprivate var playerData = PlayerData()
    
    func fetch() {
        let player = ["abdul", "danial", "jose", "cristiano", "messi"]
//        let numbers = [17, 5, 6, 7, 10]
        let numbers = [17, 5, 6, 7, 10,22,100]

        _
        = player
            .publisher
            .combineLatest(numbers.publisher) { (name, number) in
                return PlayerData(name: name, number: number)
            }
            .print()

            .sink { [unowned self] (playerData) in
                print("recieved value \(playerData.name) ")
                self.playerData = playerData
            }
    }
}
struct CombineLatest: View {
    @StateObject var vm = CombineLatestVM()
    var body: some View {
        VStack(spacing: 20) {
            Text("Players")
            
            Text("\(vm.playerData.name), \(vm.playerData.number)")
                .font(.largeTitle)
        }.task {
            vm.fetch()
        }
    }
}

#Preview {
    CombineLatest()
}
