//
//  PlanetsReducer.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

extension Starships {
    static func reducer(state: Starships.State, action: Starships.Action) -> Starships.State {
        switch action {
        case .startLoad:
            return .loading
        case .succeedLoad(let starships, let previousPage, let nextPage):
            return .loaded(data: starships, previousPage: previousPage, nextPage: nextPage)
        case .failLoad:
            return .failed
        }
    }
}
