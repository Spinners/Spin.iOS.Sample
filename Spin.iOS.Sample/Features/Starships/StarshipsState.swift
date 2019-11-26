//
//  FilmsState.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

extension StarshipsFeature {
    enum State {
        case idle
        case loading
        case loaded(data: [(Starship, Bool)], previousPage: Int?, nextPage: Int?)
        case failed
        
        struct ViewItem {
            let title: String
        }
        
        var previousPage: Int? {
            switch self {
            case .loaded(_, let previousPage, _):
                return previousPage
            default:
                return nil
            }
        }
        
        var nextPage: Int? {
            switch self {
            case .loaded(_, _, let nextPage):
                return nextPage
            default:
                return nil
            }
        }
    }
}
