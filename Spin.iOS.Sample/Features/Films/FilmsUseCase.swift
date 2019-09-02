//
//  FilmsUseCase.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxSwift

enum FilmsUseCase {
}

extension FilmsUseCase {
    static func all(allFunction: () -> Single<[Film]>) -> Observable<FilmsAction> {
        return allFunction()
            .asObservable()
            .map { .succeedLoad(films: $0) }
            .catchErrorJustReturn(.failLoad)
            .startWith(.startLoad)
    }
    
    static func search(searchFunction: (String) -> Single<[Film]>, query: String) -> Observable<FilmsAction> {
        return searchFunction(query)
            .asObservable()
            .map { .succeedLoad(films: $0) }
            .catchErrorJustReturn(.failLoad)
            .startWith(.startLoad)
    }
}
