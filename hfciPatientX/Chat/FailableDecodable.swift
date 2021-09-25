//
//  FailableDecodable.swift
//  NovaTrack
//
//  Created by Juan Pablo Rodriguez Medina on 28/02/20.
//  Copyright © 2020 Paul Zieske. All rights reserved.
//

import Foundation

//struct FailableDecodable<Base:Decodable> : Decodable {
//    let base : Base?
//
//    init(from decoder:Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        self.base = try? container.decode(Base.self)
//    }
//}


enum FailableDecodable<T:Decodable>: Decodable {
    case success(T)
    case failure(Error)
    
    init(from decoder: Decoder) throws {
        do {
            let decoded = try T(from: decoder)
            self = .success(decoded)
        }
        catch let error {
            self = .failure(error)
        }
    }
    
    var value:T? {
        switch self {
            case .success(let value):
                return value
            case .failure(_):
                return nil
        }
    }
}
