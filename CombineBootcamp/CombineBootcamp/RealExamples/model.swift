//
//  model.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 26/01/2024.
//

import Foundation

struct Post: Decodable {
    let id: Int
    let title: String
}

struct PostDetail: Decodable,Equatable {
    let title: String
}

struct Comment:Decodable,Equatable{
    let body:String
}
