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
        
        static func allIntentToFilmsAction(allFunction: @escaping () -> Single<[Film]>, intents: Observable<FilmsIntent>) -> Observable<FilmsAction> {
            return intents.flatMap { (intent) -> Observable<FilmsAction> in
                if case .all = intent {
                    return allFunction()
                    .asObservable()
                    .map { .succeedLoad(films: $0) }
                    .catchErrorJustReturn(.failLoad)
                    .startWith(.startLoad)
                }
                
                return .never()
            }
        }
        
        static func searchIntentToFilmsAction(searchFunction: @escaping (String) -> Single<[Film]>, intents: Observable<FilmsIntent>) -> Observable<FilmsAction> {
            return intents.flatMap { (intent) -> Observable<FilmsAction> in
                if case let .search(query) = intent {
                    return searchFunction(query)
                    .asObservable()
                    .map { .succeedLoad(films: $0) }
                    .catchErrorJustReturn(.failLoad)
                    .startWith(.startLoad)
                }
                
                return .never()
            }
        }
    }
}
