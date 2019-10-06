//
//  FilmsViewController.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import Reusable
import RxFlow
import RxRelay
import RxSwift
import Spin
import UIKit

class FilmsViewController: UIViewController, StoryboardBased, Stepper {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var previousButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    
    let steps = PublishRelay<Step>()
    let disposeBag = DisposeBag()
    
    private var datasource = [Film]()
    
    var commandBuilder: Films.Commands.Builder!
    let commandsRelay = PublishRelay<AnyCommand<Observable<Films.Action>, Films.State>>()
    
    @IBAction func previousTapped(_ sender: UIButton) {
        self.commandsRelay.accept(self.commandBuilder.buildPreviousCommand())
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        self.commandsRelay.accept(self.commandBuilder.buildNextCommand())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.commandsRelay.accept(self.commandBuilder.buildAllCommand())
    }
}

extension FilmsViewController {
    func emitCommands() -> Observable<AnyCommand<Observable<Films.Action>,Films.State>> {
        return self.commandsRelay.asObservable()
    }
}

extension FilmsViewController {
    func interpret(state: Films.State) -> Void {

        guard
            self.activityIndicator != nil,
            self.previousButton != nil,
            self.nextButton != nil,
            self.tableView != nil else { return }

        switch state {
        case .idle:
            self.activityIndicator.stopAnimating()
            self.previousButton.isEnabled = false
            self.nextButton.isEnabled = false
        case .loading:
            self.activityIndicator.startAnimating()
            self.tableView.alpha = 0.5
        case .loaded(let films, let previous, let next):
            self.activityIndicator.stopAnimating()
            self.tableView.alpha = 1
            self.datasource = films
            self.tableView.reloadData()
            self.previousButton.isEnabled = (previous != nil)
            self.nextButton.isEnabled = (next != nil)
        case .failed:
            self.activityIndicator.stopAnimating()
            self.previousButton.isEnabled = false
            self.nextButton.isEnabled = false
        }
    }
}

extension FilmsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filmCell", for: indexPath)
        cell.textLabel?.text = self.datasource[indexPath.row].title
        return cell
    }
}

extension FilmsViewController {
    static func make(commandBuilder: Films.Commands.Builder) -> FilmsViewController {
        let viewController = FilmsViewController.instantiate()
        viewController.commandBuilder = commandBuilder
        return viewController
    }
}


