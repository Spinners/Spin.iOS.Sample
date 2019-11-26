//
//  PlanetsCommand.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-14.
//  Copyright © 2019 Spinners. All rights reserved.
//

import Combine
import Spin
import Spin_Combine

enum StarshipsFeature {
}

extension StarshipsFeature {
    enum Commands {
        
        class Builder {
            
            private let baseUrl = "swapi.co"

            func buildAllCommand() -> AnyCommand<AnyPublisher<StarshipsFeature.Action, Never>, StarshipsFeature.State> {
                let loadApiFunction = curry3(function: Starships.Apis.load)(baseUrl)(ReactiveNetworkService())
                let loadEntityFunction = curry3(function: Starships.Entity.load)(loadApiFunction)(FavoriteService.instance.isFavorite(for:))
                return StarshipsFeature.Commands.All(loadEntityFunction: loadEntityFunction).eraseToAnyCommand()
            }
            
            func buildPreviousCommand() -> AnyCommand<AnyPublisher<StarshipsFeature.Action, Never>, StarshipsFeature.State> {
                let loadApiFunction = curry3(function: Starships.Apis.load)(baseUrl)(ReactiveNetworkService())
                let loadEntityFunction = curry3(function: Starships.Entity.load)(loadApiFunction)(FavoriteService.instance.isFavorite(for:))
                return StarshipsFeature.Commands.Previous(loadEntityFunction: loadEntityFunction).eraseToAnyCommand()
            }
            
            func buildNextCommand() -> AnyCommand<AnyPublisher<StarshipsFeature.Action, Never>, StarshipsFeature.State> {
                let loadApiFunction = curry3(function: Starships.Apis.load)(baseUrl)(ReactiveNetworkService())
                let loadEntityFunction = curry3(function: Starships.Entity.load)(loadApiFunction)(FavoriteService.instance.isFavorite(for:))
                return StarshipsFeature.Commands.Next(loadEntityFunction: loadEntityFunction).eraseToAnyCommand()
            }
        }
        
        struct All: Command {
            let loadEntityFunction: (Int?) -> AnyPublisher<([(Starship, Bool)], Int?, Int?), NetworkError>
            
            func execute(basedOn state: StarshipsFeature.State) -> AnyPublisher<StarshipsFeature.Action, Never> {
                return self.loadEntityFunction(nil)
                .map { .succeedLoad(starships: $0.0, previousPage: $0.1, nextPage: $0.2) }
                .replaceError(with: .failLoad)
                .prepend(.startLoad)
                .eraseToAnyPublisher()
            }
        }
        
        struct Previous: Command {
            let loadEntityFunction: (Int?) -> AnyPublisher<([(Starship, Bool)], Int?, Int?), NetworkError>
            
            func execute(basedOn state: StarshipsFeature.State) -> AnyPublisher<StarshipsFeature.Action, Never> {
                guard let previousPage = state.previousPage else { return Empty().eraseToAnyPublisher() }
                return self.loadEntityFunction(previousPage)
                    .map { .succeedLoad(starships: $0.0, previousPage: $0.1, nextPage: $0.2) }
                    .replaceError(with: .failLoad)
                    .prepend(.startLoad)
                    .eraseToAnyPublisher()
            }
        }
        
        struct Next: Command {
            let loadEntityFunction: (Int?) -> AnyPublisher<([(Starship, Bool)], Int?, Int?), NetworkError>
            
            func execute(basedOn state: StarshipsFeature.State) -> AnyPublisher<StarshipsFeature.Action, Never> {
                guard let nextPage = state.nextPage else { return Empty().eraseToAnyPublisher() }
                return self.loadEntityFunction(nextPage)
                    .map { .succeedLoad(starships: $0.0, previousPage: $0.1, nextPage: $0.2) }
                    .replaceError(with: .failLoad)
                    .prepend(.startLoad)
                    .eraseToAnyPublisher()
            }
        }
    }
}
