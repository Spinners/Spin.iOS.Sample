//
//  StarshipsViewController.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import Combine
import Reusable
import Spin
import UIKit

class StarshipsViewController: UIViewController, StoryboardBased {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var previouxButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    
    var disposeBag = [AnyCancellable]()
    
    private var datasource = [Starship]()
    
    var commandBuilder: Starships.Commands.Builder!
    let commandsSubject = PassthroughSubject<AnyCommand<AnyPublisher<Starships.Action, Never>, Starships.State>, Never>()
        
    @IBAction func previousTapped(_ sender: UIButton) {
        self.commandsSubject.send(self.commandBuilder.buildPreviousCommand())
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        self.commandsSubject.send(self.commandBuilder.buildNextCommand())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.commandsSubject.send(self.commandBuilder.buildAllCommand())
    }
}

extension StarshipsViewController {
    func emitCommands() -> AnyPublisher<AnyCommand<AnyPublisher<Starships.Action, Never>, Starships.State>, Never> {
        return self.commandsSubject.eraseToAnyPublisher()
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


