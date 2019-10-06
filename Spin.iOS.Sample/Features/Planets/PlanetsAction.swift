//
//  PlanetsAction.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

extension Planets {
    enum Action {
        case startLoad
        case succeedLoad(planets: [Planet], previousPage: Int?, nextPage: Int?)
        case failLoad
    }
}
