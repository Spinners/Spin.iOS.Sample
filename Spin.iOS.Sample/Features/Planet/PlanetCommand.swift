//
//  PlanetCommand.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-11-26.
//  Copyright © 2019 Spinners. All rights reserved.
//

import ReactiveSwift
import Spin
import Spin_ReactiveSwift

enum PlanetFeature {
    enum Commands {

        class Builder {
            func buildLoadCommand() -> AnyCommand<SignalProducer<PlanetFeature.Action, Never>, PlanetFeature.State> {
                return PlanetFeature.Commands.Load(loadFavoriteFunction: FavoriteService.instance.isFavorite(for:)).eraseToAnyCommand()
            }

            func buildSetFavoriteCommand() -> AnyCommand<SignalProducer<PlanetFeature.Action, Never>, PlanetFeature.State> {
                return PlanetFeature.Commands.SetFavorite(persistFavoriteFunction: FavoriteService.instance.set(favorite:for:), isFavorite: true).eraseToAnyCommand()
            }

            func buildUnsetFavoriteCommand() -> AnyCommand<SignalProducer<PlanetFeature.Action, Never>, PlanetFeature.State> {
                return PlanetFeature.Commands.SetFavorite(persistFavoriteFunction: FavoriteService.instance.set(favorite:for:), isFavorite: false).eraseToAnyCommand()
            }
        }

        struct Load: Command {
            let loadFavoriteFunction: (String) -> Bool

            func execute(basedOn state: PlanetFeature.State) -> SignalProducer<PlanetFeature.Action, Never> {
                guard case let .idle(planet) = state else { return .empty }

                return SignalProducer<Bool, Never>.init {
                    return self.loadFavoriteFunction(planet.url)
                }
                .map { PlanetFeature.Action.load(planet: planet, favorite: $0) }
                .prefix(value: PlanetFeature.Action.startLoading(planet: planet))
            }
        }

        struct SetFavorite: Command {
            let persistFavoriteFunction: (Bool, String) -> Void
            let isFavorite: Bool

            func execute(basedOn state: PlanetFeature.State) -> SignalProducer<PlanetFeature.Action, Never> {
                guard case let .loaded(planet, _) = state else { return .empty }

                return SignalProducer<Void, Never>.init {
                    self.persistFavoriteFunction(self.isFavorite, planet.url)
                }
                .delay(2, on: QueueScheduler())
                .map { PlanetFeature.Action.load(planet: planet, favorite: self.isFavorite) }
                .prefix(value: PlanetFeature.Action.startSettingFavorite(planet: planet, favorite: isFavorite))
            }
        }
    }
}
