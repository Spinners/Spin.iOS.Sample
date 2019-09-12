//
//  FilmsState.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

extension Films {
    enum State {
        case idle
        case loading
        case loaded([Film])
        case failed
        
        struct ViewItem {
            let title: String
        }
    }
}
