//
//  PlanetsReducer.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

extension PlanetsFeature {
    static func reducer(state: PlanetsFeature.State, action: PlanetsFeature.Action) -> PlanetsFeature.State {
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
