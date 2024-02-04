//
//  Empty.swift
//  Empty&Fail
//
//  Created by Abdul Ahad on 30.12.23.
//

import Foundation
import SwiftUI
import Combine
//“ Combine has an Empty publisher. It is simply a publisher that publishes nothing. You can have it finish immediately or fail immediately. You can also have it never complete and just keep the pipeline open”
//

//replaceError(with:)
//if the upstream publisher fails with an error, this publisher emits the provided element, then finishes normally.

struct NilData:Error{}
class EmptyVM:ObservableObject{
    @Published var throwableData = [String]()
    var cancellable = [AnyCancellable]()
    func fetch() {
        let data = ["1","2",nil]
        throwableData.removeAll()
     data.publisher
            .tryMap { unwrappedItem in
            guard let item = unwrappedItem else{
                throw NilData()
            }
            return item
        }
//            .replaceError(with: "NilData")
            .catch{ (error) in
           return Empty()
        }
        .print("Example")
        .sink { [weak self](item) in
            self?.throwableData.append(item)
        }
        .store(in: &cancellable)
    }
}


struct EmptyContentView: View {
    @StateObject var vm = EmptyVM()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, worldss!")
             List(vm.throwableData, id: \.self) { item in
                 Text(item)}

            
        }
        .padding()
        .onAppear(perform: {
            vm.fetch()
        })
    }
}

#Preview {
    EmptyContentView()
}
