//
//  ContentView.swift
//  Just
//
//  Created by Abdul Ahad on 01.01.24.
//

import SwiftUI
import Combine
/*“Using the Just publisher can turn any variable into a publisher. It will take any value you have and send it through a pipeline that you attach to it one time and then finish (stop) the pipeline.”
*/
//“This means you can attach pipelines to any property or value.”

class justViewModel:ObservableObject {
    @Published var firstNameFromArray = ""
    func fetch(){
        let data =  ["abdul","kareem","abdullah"]
        Just(data[0]).map{$0.uppercased()}
            .print()
            .assign(to: &$firstNameFromArray)
    }
}
struct justVieView: View {
    @StateObject var vm = justViewModel()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, \(vm.firstNameFromArray)!")
            
            Button("tap here to get the name"){
                vm.fetch()
            }
        }
        .padding()
        
    }
}

#Preview {
    justVieView()
}
