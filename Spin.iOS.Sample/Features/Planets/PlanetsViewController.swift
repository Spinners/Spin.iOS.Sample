//
//  PlanetsViewController.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import ReactiveSwift
import Reusable
import Spin
import Spin_ReactiveSwift
import RxFlow
import RxRelay
import UIKit

class PlanetsViewController: UIViewController, StoryboardBased, Stepper {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var previouxButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!

    let steps = PublishRelay<Step>()

    let disposeBag = CompositeDisposable()
    
    private var datasource = [(Planet, Bool)]()
    
    var commandBuilder: PlanetsFeature.Commands.Builder!
    let commandSignal = Signal<AnyCommand<SignalProducer<PlanetsFeature.Action, Never>, PlanetsFeature.State>, Never>.pipe()

    @IBAction func previousTapped(_ sender: UIButton) {
        self.commandSignal.input.send(value: self.commandBuilder.buildPreviousCommand())
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        self.commandSignal.input.send(value: self.commandBuilder.buildNextCommand())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.commandSignal.input.send(value: self.commandBuilder.buildAllCommand())
    }
}

extension PlanetsViewController {
    func emitCommands() -> SignalProducer<AnyCommand<SignalProducer<PlanetsFeature.Action, Never>, PlanetsFeature.State>, Never> {
        return self.commandSignal.output.producer
    }
}

extension PlanetsViewController {
    func interpret(state: PlanetsFeature.State) -> Void {

        guard
            self.activityIndicator != nil,
            self.previouxButton != nil,
            self.nextButton != nil,
            self.tableView != nil else { return }

        switch state {
        case .idle:
            self.activityIndicator.stopAnimating()
            self.previouxButton.isEnabled = false
            self.nextButton.isEnabled = false
        case .loading:
            self.activityIndicator.startAnimating()
            self.tableView.alpha = 0.5
            self.previouxButton.isEnabled = false
            self.nextButton.isEnabled = false
        case .loaded(let planets, let previous, let next):
            self.activityIndicator.stopAnimating()
            self.tableView.alpha = 1
            self.datasource = planets
            self.tableView.reloadData()
            self.previouxButton.isEnabled = (previous != nil)
            self.nextButton.isEnabled = (next != nil)
        case .failed:
            self.activityIndicator.stopAnimating()
            self.previouxButton.isEnabled = false
            self.nextButton.isEnabled = false
        }
    }
}

extension PlanetsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "planetCell", for: indexPath)
        cell.textLabel?.text = self.datasource[indexPath.row].0.name
        cell.imageView?.image = self.datasource[indexPath.row].1 ? UIImage(systemName: "star.fill") : nil
        return cell
    }
}

extension PlanetsViewController {
    static func make(commandBuilder: PlanetsFeature.Commands.Builder) -> PlanetsViewController {
        let viewController = PlanetsViewController.instantiate()
        viewController.commandBuilder = commandBuilder
        return viewController
    }
}

extension PlanetsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let planet = self.datasource[indexPath.row].0
        self.steps.accept(AppSteps.planet(planet: planet))
    }
}


