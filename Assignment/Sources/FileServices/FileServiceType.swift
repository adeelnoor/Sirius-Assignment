//
//  FileServiceType.swift
//  Assignment
//
//  Created by Adeel-dev on 3/2/22.
//

import Foundation
import Combine

protocol FileServiceType: AnyObject {
    
    @discardableResult
    func load() -> AnyPublisher<[City], Error>
    
    @discardableResult
    func search(from cities: [City], name: String) -> AnyPublisher<[City], Error>
}
