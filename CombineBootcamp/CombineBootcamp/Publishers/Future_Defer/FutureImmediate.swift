//
//  FutureImmediate.swift
//  Future
//
//  Created by Abdul Ahad on 31.12.23.
//

import Foundation
import SwiftUI
import Combine

//future publishers executre immediately whether they have a subscriber or not
class ImmediateFutureViewModel:ObservableObject{
    @Published var data = ""
    
    func fetch(){
      let _ = Future<String,Never>{
            promise in
            self.data = "hello world"
        }.print("hello future : ")
//            .assign(to: &$data)
//            .assign(to: &$data)
//            .assign(to: &$data)
    }
}
struct FutureImmediateView: View {
    @StateObject var vm = ImmediateFutureViewModel()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("immediate futuress")
            
            Text(vm.data)
            
            
            
        }.onAppear{
            vm.fetch()
        }
        .padding()
        
    }
}

#Preview {
    FutureImmediateView()
}
