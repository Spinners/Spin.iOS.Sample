//
//  PlanetsReducer.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

extension Planets {
    static func reducer(state: Planets.State, action: Planets.Action) -> Planets.State {
        switch action {
        case .startLoad:
            return .loading
        case .succeedLoad(let planets, let previousPage, let nextPage):
            return .loaded(data: planets, previousPage: previousPage, nextPage: nextPage)
        case .failLoad:
            return .failed
        }
    }
}
