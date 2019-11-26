//
//  FavoriteService.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-11-24.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import Foundation

class FavoriteService {

    static let instance = FavoriteService()

    private init() {}

    private var storage = [String: Bool]()

    func set(favorite: Bool, for resource: String) {
        self.storage[resource] = favorite
    }

    func isFavorite(for resource: String) -> Bool {
        return self.storage[resource] ?? false
    }
}
