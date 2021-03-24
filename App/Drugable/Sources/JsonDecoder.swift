//
//  JsonDecoder.swift
//  Drugable
//
//  Created by Vladimir Jeremic on 3/17/21.
//

import Foundation
import Combine
import UIKit

enum DecodingError: Error {
    case parsing(description: String)
    case network(description: String)
}

func JSONdecodeFromAssets<T: Decodable>(assetName name: String, type: T.Type) -> AnyPublisher<T, DecodingError> {
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    
    if let asset = NSDataAsset(name: name, bundle: Bundle.main)?.data {
        return JSONdecode(asset, type: type)
    }
    
    return Fail(outputType: T.self, failure: DecodingError.parsing(description: "Cannot parse")).eraseToAnyPublisher()
}

func JSONdecode<T: Decodable>(_ data: Data, type: T.Type) -> AnyPublisher<T, DecodingError> {
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    
    return Just(data)
        .decode(type: T.self, decoder: decoder)
        .mapError { error in
            .parsing(description: "Cannot parse")
        }.eraseToAnyPublisher()
}
