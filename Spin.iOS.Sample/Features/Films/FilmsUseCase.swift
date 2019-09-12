//
//  FilmsUseCase.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxSwift

extension Films {
    enum UseCase {
        
        static func allFilmsAction(allFunction: @escaping () -> Single<[Film]>) -> Observable<Films.Action> {
            return allFunction()
                .asObservable()
                .map { .succeedLoad(films: $0) }
                .catchErrorJustReturn(.failLoad)
                .startWith(.startLoad)
        }
        
        static func searchFilmsAction(searchFunction: @escaping (String) -> Single<[Film]>, query: String) -> Observable<Films.Action> {
            return searchFunction(query)
                .asObservable()
                .map { .succeedLoad(films: $0) }
                .catchErrorJustReturn(.failLoad)
                .startWith(.startLoad)
        }
    }
}
