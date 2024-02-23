//
//  Zip.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 23/02/2024.
//

import SwiftUI

//Using the zip operator you can connect two pipelines and then use a closure to process the data from each publisher in some way. There is also a zip3 and zip4 to. zip combines values from both publisher and sends out a tuple

//items only get
//published when there is a
//value from BOTH publishers.

//connect even more pipelines together. You will still have just one pipeline after connecting all the pipelines that send down the data to your subscriber.
private struct PlayerData: Identifiable {
    let id = UUID()
    var name = ""
    var number = 0
}

class ZipVM: ObservableObject {
    @Published fileprivate var playerData = PlayerData()
    
    func fetch() {
        let player = ["abdul", "danial", "jose", "cristiano", "messi"]
//        let numbers = [17, 5, 6, 7, 10]
        let numbers = [17, 5, 6, 7, 10,22,100,20]

        _
        = player
            .publisher
            .zip(numbers.publisher) { (name, number) in
                return PlayerData(name: name, number: number)
            }
            .print()
            .sink { [unowned self] (playerData) in
                print("recieved value \(playerData.name) ")
                self.playerData = playerData
            }
    }
}
struct Zip: View {
    @StateObject var vm = ZipVM()
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
    Zip()
}
