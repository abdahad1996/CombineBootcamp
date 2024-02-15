//
//  CompactMap.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 14/02/2024.
//

import SwiftUI
import Combine

//The removeDuplicates(by:) operator works like the removeDuplicates operator but for objects that do not conform to the Equatable protocol. (Objects that
//conform to the Equatable protocol can be compared in code to see if they are equal or not.)
//Since removeDuplicates won’t be able to tell if the previous item is the same as the current item, you can specify what makes the two items equal inside this closure.


private struct UserId: Identifiable {
    let id = UUID()
    var email = ""
    var name = ""
}
class RemoveDuplicatesByVM:ObservableObject {
    @Published fileprivate var data: [UserId] = []
    
    func fetch() {
        let dataIn = [UserId(email: "joe.m@gmail.com", name: "Joe M."),
                      UserId(email: "joe.m@gmail.com", name: "Joseph M."),
                      UserId(email: "christina@icloud.com", name: "Christina B."),
                      UserId(email: "enzo@enel.it", name: "Lorenzo D."),
                      UserId(email: "enzo@enel.it", name: "Enzo D.")]
        
        _ = dataIn.publisher
            .removeDuplicates(by: { user1, user2 in
                return user1.email == user2.email
            })
            .print()
            .sink(receiveValue: { [weak self] value in
                self?.data.append(value)
            })
        
    }
}
struct RemoveDuplicatesBy: View {
    @StateObject var vm = RemoveDuplicatesByVM()
    var body: some View {

        List(vm.data, id: \.id) { user in
            Text(user.email)
        }.task {
            vm.fetch()
        }
        
    }
}

#Preview {
    RemoveDuplicatesBy()
}
