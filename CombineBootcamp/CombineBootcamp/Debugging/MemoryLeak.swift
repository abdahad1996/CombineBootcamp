//
//  MemoryLeak.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 24/02/2024.
//

import SwiftUI

struct MemoryLeak: View {
    @State private var showSheet = false
    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                showSheet.toggle()
            }) {
                Text("show sheet")
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal)
                    .background(Capsule().fill(Color.blue))
            }
        }.sheet(isPresented: $showSheet, content: {
            MemoryLeakDetail()
        })
    }
}

class MemoryDetailVM: ObservableObject {
    @Published var data = ""
    func fetch() {
        data = "New value"
    }
    deinit {
        print("Unloaded MemoryDetailVM")
    }
}
struct MemoryLeakDetail:View {
    @StateObject var vm = MemoryDetailVM()
    var body: some View{
        VStack{
            Text(vm.data)
        }.task {
            vm.fetch()
        }
    }
}

#Preview {
    MemoryLeak()
}
