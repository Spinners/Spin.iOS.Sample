//
//  FilmsCommand.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-14.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxSwift
import Spin
import Spin_RxSwift

enum PeoplesFeature {
}

extension PeoplesFeature {
    enum Commands {
        
        class Builder {
            
            private let baseUrl = "swapi.co"

            func buildAllCommand() -> AnyCommand<Observable<PeoplesFeature.Action>, PeoplesFeature.State> {
                let loadApiFunction = curry3(function: Peoples.Apis.load)(baseUrl)(ReactiveNetworkService())
                let loadEntityFunction = curry3(function: Peoples.Entity.load)(loadApiFunction)(FavoriteService.instance.isFavorite(for:))
                return PeoplesFeature.Commands.All(loadEntityFunction: loadEntityFunction).eraseToAnyCommand()
            }
            
            func buildPreviousCommand() -> AnyCommand<Observable<PeoplesFeature.Action>, PeoplesFeature.State> {
                let loadApiFunction = curry3(function: Peoples.Apis.load)(baseUrl)(ReactiveNetworkService())
                let loadEntityFunction = curry3(function: Peoples.Entity.load)(loadApiFunction)(FavoriteService.instance.isFavorite(for:))
                return PeoplesFeature.Commands.Previous(loadEntityFunction: loadEntityFunction).eraseToAnyCommand()
            }
            
            func buildNextCommand() -> AnyCommand<Observable<PeoplesFeature.Action>, PeoplesFeature.State> {
                let loadApiFunction = curry3(function: Peoples.Apis.load)(baseUrl)(ReactiveNetworkService())
                let loadEntityFunction = curry3(function: Peoples.Entity.load)(loadApiFunction)(FavoriteService.instance.isFavorite(for:))
                return PeoplesFeature.Commands.Next(loadEntityFunction: loadEntityFunction).eraseToAnyCommand()
            }
        }
        
        struct All: Command {
            let loadEntityFunction: (Int?) -> Single<([(People, Bool)], Int?, Int?)>
            
            func execute(basedOn state: PeoplesFeature.State) -> Observable<PeoplesFeature.Action> {
                return self.loadEntityFunction(nil)
                .asObservable()
                .map { .succeedLoad(peoples: $0.0, previousPage: $0.1, nextPage: $0.2) }
                .catchErrorJustReturn(.failLoad)
                .startWith(.startLoad)
            }
        }
        
        struct Previous: Command {
            let loadEntityFunction: (Int?) -> Single<([(People, Bool)], Int?, Int?)>
            
            func execute(basedOn state: PeoplesFeature.State) -> Observable<PeoplesFeature.Action> {
                guard let previousPage = state.previousPage else { return .empty() }
                return self.loadEntityFunction(previousPage)
                    .asObservable()
                    .map { .succeedLoad(peoples: $0.0, previousPage: $0.1, nextPage: $0.2) }
                    .catchErrorJustReturn(.failLoad)
                    .startWith(.startLoad)
            }
        }
        
        struct Next: Command {
            let loadEntityFunction: (Int?) -> Single<([(People, Bool)], Int?, Int?)>
            
            func execute(basedOn state: PeoplesFeature.State) -> Observable<PeoplesFeature.Action> {
                guard let nextPage = state.nextPage else { return .empty() }
                return self.loadEntityFunction(nextPage)
                    .asObservable()
                    .map { .succeedLoad(peoples: $0.0, previousPage: $0.1, nextPage: $0.2) }
                    .catchErrorJustReturn(.failLoad)
                    .startWith(.startLoad)
            }
        }
    }
}
