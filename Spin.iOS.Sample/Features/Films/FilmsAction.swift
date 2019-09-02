//
//  FilmsAction.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

enum FilmsAction {
    case startLoad
    case succeedLoad(films: [Film])
    case failLoad
}
