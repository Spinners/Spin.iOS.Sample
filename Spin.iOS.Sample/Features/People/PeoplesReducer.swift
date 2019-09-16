//
//  FilmsReducer.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

extension Peoples {
    static func reducer(state: Peoples.State, action: Peoples.Action) -> Peoples.State {
        switch action {
        case .startLoad:
            return .loading
        case .succeedLoad(let peoples, let previousPage, let nextPage):
            return .loaded(data: peoples, previousPage: previousPage, nextPage: nextPage)
        case .failLoad:
            return .failed
        }
    }
}
