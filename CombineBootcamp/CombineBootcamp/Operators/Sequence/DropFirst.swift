//
//  DropFirst.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 13/02/2024.
//

import SwiftUI

enum validation {
    case invalid
    case ok
    case notEvaluated
}
//The dropFirst operator can prevent a certain number of items from initially being published.
class DropFirstVm:ObservableObject{
    
    @Published var text = ""
    @Published var textFieldValidation:validation = .notEvaluated
    
    init(){
        $text
            .dropFirst()
            .map{ text -> validation in
            text.count < 5 ? .invalid:.ok
        }.assign(to: &$textFieldValidation)
    }
}
struct DropFirst: View {
    @StateObject var vm = DropFirstVm()
    @State var isBool = true 
    var body: some View {
        HStack {
            Image(systemName: "envelope")
                .foregroundColor(.gray)
                .font(.headline)
            TextField("write texts", text: $vm.text)
            
        }
        .padding(8)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(statusColor, lineWidth: 1))
    }
    
    var statusColor: Color {
    switch vm.textFieldValidation {
        case .ok:
            return Color.green
        case .invalid:
            return Color.red
        default:
            return Color.secondary
        }
    }
}

#Preview {
    DropFirst()
}
