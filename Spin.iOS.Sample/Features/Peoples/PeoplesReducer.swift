//
//  FilmsReducer.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

extension PeoplesFeature {
    static func reducer(state: PeoplesFeature.State, action: PeoplesFeature.Action) -> PeoplesFeature.State {
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
