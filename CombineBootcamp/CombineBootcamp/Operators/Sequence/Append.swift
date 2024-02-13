//
//  Append.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 13/02/2024.
//

import SwiftUI
import Combine
//A Sequence publisher is being
//used here which automatically
//finishes when the last item is
//published. So the append will
//always work here.

//The append operator will publish data after the publisher has sent out all of its items.

//Just keep this in mind when using this operator. You want to use it on a pipeline that
//actually finishes.
class AppendVM:ObservableObject{
    @Published var pubData = [String]()
    var cancellable: AnyCancellable?
    
    func append(){
        pubData.append("NEW VALUE")
    }
    func fetch(){
        let data = ["A","B","C"]
        
        cancellable = data.publisher
           
            .append("D")
            .append("l")

            .print()
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue:{ [weak self] value in
                print(value)
                  self?.pubData.append(value)
            })
    }
    
    func fetchReadandUnReadMessages(){
        let read = ["A","B","C"]
        let unread = ["d","e","f"]
        cancellable = read.publisher
           
            .append(unread)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue:{ [weak self] value in
                print(value)
                self?.pubData.append(value)
            })
    }
}

struct Append: View {
    @StateObject var vm = AppendVM()
    var body: some View {
        VStack {
            List(vm.pubData, id: \.self) { datum in
                Text(datum)
                
            }.onAppear{
                vm.fetchReadandUnReadMessages()
        }
            Button(action: {
                vm.append()
            }) {
                Text("ADD VALUE")
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal)
                    .background(Capsule().fill(Color.blue))
            }
        }
    }
}

#Preview {
    Append()
}
