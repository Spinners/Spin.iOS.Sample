//
//  PlanetViewController.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-11-20.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import UIKit
import ReactiveSwift
import Reusable
import Spin
import Spin_ReactiveSwift

class PlanetViewController: UIViewController, StoryboardBased {

    @IBOutlet private weak var planetNameLabel: UILabel!
    @IBOutlet private weak var planetDiameterLabel: UILabel!
    @IBOutlet private weak var planetPopulationLabel: UILabel!
    @IBOutlet private weak var planetGravityLabel: UILabel!
    @IBOutlet private weak var planetOrbitalPeriodLabel: UILabel!
    @IBOutlet private weak var planetRotationPeriodLabel: UILabel!
    @IBOutlet private weak var planetClimateLabel: UILabel!
    @IBOutlet private weak var planetFavoriteSwitch: UISwitch!
    @IBOutlet private weak var planetFavoriteIsLoadingActivity: UIActivityIndicatorView!

    let disposeBag = CompositeDisposable()

    var commandBuilder: PlanetFeature.Commands.Builder!
    let commandSignal = Signal<AnyCommand<SignalProducer<PlanetFeature.Action, Never>, PlanetFeature.State>, Never>.pipe()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.commandSignal.input.send(value: self.commandBuilder.buildLoadCommand())
    }

    @IBAction func setFavorite(_ sender: UISwitch) {
        if sender.isOn {
            self.commandSignal.input.send(value: self.commandBuilder.buildSetFavoriteCommand())
        } else {
            self.commandSignal.input.send(value: self.commandBuilder.buildUnsetFavoriteCommand())
        }
    }
}

extension PlanetViewController {
    func emitCommands() -> SignalProducer<AnyCommand<SignalProducer<PlanetFeature.Action, Never>, PlanetFeature.State>, Never> {
        return self.commandSignal.output.producer
    }
}

extension PlanetViewController {
    func interpret(state: PlanetFeature.State) -> Void {

        switch state {
        case .idle:
            return
        case .loading(let planet):
            self.display(planet: planet)
            self.planetFavoriteIsLoadingActivity.startAnimating()
            self.planetFavoriteSwitch.isHidden = true
            self.planetFavoriteSwitch.setOn(false, animated: true)
        case .loaded(let planet, let favorite):
            self.display(planet: planet)
            self.planetFavoriteIsLoadingActivity.stopAnimating()
            self.planetFavoriteSwitch.isHidden = false
            self.planetFavoriteSwitch.setOn(favorite, animated: true)
        case .enablingFavorite(let planet, let favorite):
            self.display(planet: planet)
            self.planetFavoriteIsLoadingActivity.startAnimating()
            self.planetFavoriteSwitch.isHidden = true
            self.planetFavoriteSwitch.setOn(favorite, animated: true)
        }
    }

    private func display(planet: Planet) {
        self.planetNameLabel.text = planet.name
        self.planetDiameterLabel.text = planet.diameter
        self.planetPopulationLabel.text = planet.population
        self.planetGravityLabel.text = planet.gravity
        self.planetOrbitalPeriodLabel.text = planet.orbitalPeriod
        self.planetRotationPeriodLabel.text = planet.rotationPeriod
        self.planetClimateLabel.text = planet.climate
    }
}

extension PlanetViewController {
    static func make(commandBuilder: PlanetFeature.Commands.Builder) -> PlanetViewController {
        let viewController = PlanetViewController.instantiate()
        viewController.commandBuilder = commandBuilder
        return viewController
    }
}
