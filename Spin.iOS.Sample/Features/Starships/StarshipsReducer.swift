//
//  PlanetsReducer.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

extension StarshipsFeature {
    static func reducer(state: StarshipsFeature.State, action: StarshipsFeature.Action) -> StarshipsFeature.State {
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
