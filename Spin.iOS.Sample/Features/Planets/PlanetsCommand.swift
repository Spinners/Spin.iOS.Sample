//
//  PlanetsCommand.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-14.
//  Copyright © 2019 Spinners. All rights reserved.
//

import ReactiveSwift
import Spin
import Spin_ReactiveSwift

enum PlanetsFeature {
}

extension PlanetsFeature {
    enum Commands {
        
        class Builder {
            
            private let baseUrl = "swapi.co"

            func buildAllCommand() -> AnyCommand<SignalProducer<PlanetsFeature.Action, Never>, PlanetsFeature.State> {
                let loadApiFunction = curry3(function: Planets.Apis.load)(baseUrl)(ReactiveNetworkService())
                let loadEntityFunction = curry3(function: Planets.Entity.load)(loadApiFunction)(FavoriteService.instance.isFavorite(for:))
                return PlanetsFeature.Commands.All(loadEntityFunction: loadEntityFunction).eraseToAnyCommand()
            }
            
            func buildPreviousCommand() -> AnyCommand<SignalProducer<PlanetsFeature.Action, Never>, PlanetsFeature.State> {
                let loadApiFunction = curry3(function: Planets.Apis.load)(baseUrl)(ReactiveNetworkService())
                let loadEntityFunction = curry3(function: Planets.Entity.load)(loadApiFunction)(FavoriteService.instance.isFavorite(for:))
                return PlanetsFeature.Commands.Previous(loadEntityFunction: loadEntityFunction).eraseToAnyCommand()
            }
            
            func buildNextCommand() -> AnyCommand<SignalProducer<PlanetsFeature.Action, Never>, PlanetsFeature.State> {
                let loadApiFunction = curry3(function: Planets.Apis.load)(baseUrl)(ReactiveNetworkService())
                let loadEntityFunction = curry3(function: Planets.Entity.load)(loadApiFunction)(FavoriteService.instance.isFavorite(for:))
                return PlanetsFeature.Commands.Next(loadEntityFunction: loadEntityFunction).eraseToAnyCommand()
            }
        }
        
        struct All: Command {
            let loadEntityFunction: (Int?) -> SignalProducer<([(Planet, Bool)], Int?, Int?), NetworkError>
            
            func execute(basedOn state: PlanetsFeature.State) -> SignalProducer<PlanetsFeature.Action, Never> {
                return self.loadEntityFunction(nil)
                    .map { .succeedLoad(planets: $0.0, previousPage: $0.1, nextPage: $0.2) }
                    .flatMapError { (error) -> SignalProducer<PlanetsFeature.Action, Never> in
                        return SignalProducer<PlanetsFeature.Action, Never>(value: .failLoad)
                }
                .prefix(value: .startLoad)
            }
        }
        
        struct Previous: Command {
            let loadEntityFunction: (Int?) -> SignalProducer<([(Planet, Bool)], Int?, Int?), NetworkError>
            
            func execute(basedOn state: PlanetsFeature.State) -> SignalProducer<PlanetsFeature.Action, Never> {
                guard let previousPage = state.previousPage else { return SignalProducer<PlanetsFeature.Action, Never>.empty }
                return self.loadEntityFunction(previousPage)
                    .map { .succeedLoad(planets: $0.0, previousPage: $0.1, nextPage: $0.2) }
                    .flatMapError { (error) -> SignalProducer<PlanetsFeature.Action, Never> in
                        return SignalProducer<PlanetsFeature.Action, Never>(value: .failLoad)
                }
                .prefix(value: .startLoad)
            }
        }
        
        struct Next: Command {
            let loadEntityFunction: (Int?) -> SignalProducer<([(Planet, Bool)], Int?, Int?), NetworkError>
            
            func execute(basedOn state: PlanetsFeature.State) -> SignalProducer<PlanetsFeature.Action, Never> {
                guard let nextPage = state.nextPage else { return SignalProducer<PlanetsFeature.Action, Never>.empty }
                return self.loadEntityFunction(nextPage)
                    .map { .succeedLoad(planets: $0.0, previousPage: $0.1, nextPage: $0.2) }
                    .flatMapError { (error) -> SignalProducer<PlanetsFeature.Action, Never> in
                        return SignalProducer<PlanetsFeature.Action, Never>(value: .failLoad)
                }
                .prefix(value: .startLoad)
            }
        }
    }
}
