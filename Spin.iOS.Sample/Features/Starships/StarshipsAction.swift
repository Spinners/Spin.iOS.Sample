//
//  PlanetsAction.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

extension Starships {
    enum Action {
        case startLoad
        case succeedLoad(starships: [Starship], previousPage: Int?, nextPage: Int?)
        case failLoad
    }
}
