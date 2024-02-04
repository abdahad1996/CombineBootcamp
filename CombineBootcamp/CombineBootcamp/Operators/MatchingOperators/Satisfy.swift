//
//  Satisfy.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 04/02/2024.
//

import SwiftUI

//Use the allSatisfy operator to test all items coming through the pipeline meet your specified criteria. As soon as one item does NOT meet your criteria, a false is
//published and the pipeline is finished/closed. Otherwise, if all items met your criteria then a true is published.

class SatisfyViewModel:ObservableObject{
    let values = [2,4,6,8,10,11]
    @Published var isTrue:Bool = false
    
    init(){
        satisfy()
    }
    func satisfy(){
        values.publisher
            .print()
            .allSatisfy{
            $0.isMultiple(of: 2)
        }.assign(to: &$isTrue)
    }
}


struct Satisfy: View {
    @StateObject var satisfyViewModel = SatisfyViewModel()
    var body: some View {
        if satisfyViewModel.isTrue {
            Text("the value is a multiple pf 2")
        }else{
            Text("the value is not a multiple of 2")
        }
        
    }
}

#Preview {
    Satisfy()
}
