//
//  ListResponse.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

struct ListResponse<Entity: Decodable>: Decodable {
    let count: Int
    let previous: String
    let next: String
    let results: [Entity]
}
