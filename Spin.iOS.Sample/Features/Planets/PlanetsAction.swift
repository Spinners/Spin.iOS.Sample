//
//  PlanetsAction.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

extension PlanetsFeature {
    enum Action {
        case startLoad
        case succeedLoad(planets: [(Planet, Bool)], previousPage: Int?, nextPage: Int?)
        case failLoad
    }
}
