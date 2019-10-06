//
//  StarshipsViewController.swift
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

class StarshipsViewController: UIViewController, StoryboardBased, Stepper {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var previouxButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    
    let steps = PublishRelay<Step>()
    let disposeBag = DisposeBag()
    
    private var datasource = [Starship]()
    
    var commandBuilder: Starships.Commands.Builder!
    let commandsRelay = PublishRelay<AnyCommand<Observable<Starships.Action>, Starships.State>>()
        
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

extension StarshipsViewController {
    func emitCommands() -> Observable<AnyCommand<Observable<Starships.Action>, Starships.State>> {
        return self.commandsRelay.asObservable()
    }
}

extension StarshipsViewController {
    func interpret(state: Starships.State) -> Void {

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
        case .loaded(let starships, let previous, let next):
            self.activityIndicator.stopAnimating()
            self.tableView.alpha = 1
            self.datasource = starships
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

extension StarshipsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "starshipCell", for: indexPath)
        cell.textLabel?.text = self.datasource[indexPath.row].name
        return cell
    }
}

extension StarshipsViewController {
    static func make(commandBuilder: Starships.Commands.Builder) -> StarshipsViewController {
        let viewController = StarshipsViewController.instantiate()
        viewController.commandBuilder = commandBuilder
        return viewController
    }
}


