//
//  CompactMap.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 14/02/2024.
//

import SwiftUI
import Combine

//You will find the tryRemoveDuplicates is just like the removeDuplicates(by:) operator except it also allows you to throw an error within the closure. In the
//closure where you set your condition on what is a duplicate or not, you can throw an error if needed and the subscriber (or other operators) will then handle the
//error.

private struct UserId: Identifiable {
    let id = UUID()
    var email = ""
    var name = ""
}
private struct RemoveDuplicateError: Error, Identifiable {
    let id = UUID()
    let description = "There was a problem removing duplicate items."
}
class TryRemoveDuplicatesByVM:ObservableObject {
    @Published fileprivate var data: [UserId] = []
    @Published fileprivate var removeDuplicateError: RemoveDuplicateError?
    func fetch() {
        let dataIn = [UserId(email: "joe.m@gmail.com", name: "Joe M."),
                      UserId(email: "joe.m@gmail.com", name: "Joseph M."),
                      UserId(email: "christina@icloud.com", name: "Christina B."),
                      UserId(email: "enzo@enel.it", name: "Lorenzo D."),
                      UserId(email: "enzo@enel.it", name: "Enzo D."),
                      UserId(email: "N/A", name: "N/A"),
                      UserId(email: "N/A", name: "N/A")]
        
        _ = dataIn.publisher
            .tryRemoveDuplicates(by: { user1, user2 in
                if (user1.email == "N/A" && user2.email == "N/A") {
                    throw RemoveDuplicateError()
                }
                return user1.email == user2.email
            })
            .print()
            .sink(receiveCompletion: {[weak self]completion in
                if case .failure(let error) = completion {
                    self?.removeDuplicateError = error as? RemoveDuplicateError
                }
            }, receiveValue: { [weak self] value in
                self?.data.append(value)
            })
        
    }
}
struct TryRemoveDuplicatesBy: View {
    @StateObject var vm = TryRemoveDuplicatesByVM()
    var body: some View {

        List(vm.data, id: \.id) { user in
            Text(user.email)
        }.task {
            vm.fetch()
        }
        .alert(item: $vm.removeDuplicateError) { error in
        Alert(title: Text("Error"), message: Text(error.description))
        }
    }
}

#Preview {
    TryRemoveDuplicatesBy()
}
