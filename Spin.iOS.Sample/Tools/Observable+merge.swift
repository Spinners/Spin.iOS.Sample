//
//  Observable+merge.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-14.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxSwift

extension Observable {
    static func merge<A>(functions: (Observable<A>) -> Observable<Element>...) -> (Observable<A>) -> Observable<Element> {
        return { (a: Observable<A>) -> Observable<Element> in
            let results: [Observable<Element>] = functions.map { $0(a) }
            return Observable<Element>.merge(results)
        }
    }
}
