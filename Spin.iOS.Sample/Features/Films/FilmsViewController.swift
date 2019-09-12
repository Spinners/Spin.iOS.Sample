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
import UIKit

class FilmsViewController: UIViewController, StoryboardBased, Stepper {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    let steps = PublishRelay<Step>()
    let disposeBag = DisposeBag()
    
    private var datasource = [Film]()
    
    var buildAllFilmsAction: (() -> Observable<Films.Action>)!
    var buildSearchFilmsAction: ((String) -> Observable<Films.Action>)!
    let actionsRelay = PublishRelay<Films.Action>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = self.buildAllFilmsAction()
            .takeUntil(self.rx.deallocating)
            .bind(to: self.actionsRelay)
    }
}

extension FilmsViewController {
    func emitActions() -> Observable<Films.Action> {
        return self.actionsRelay.asObservable()
    }
}

extension FilmsViewController {
    func interpret(state: Films.State) -> Void {
        switch state {
        case .idle:
            self.activityIndicator.stopAnimating()
        case .loading:
            self.activityIndicator.startAnimating()
        case .loaded(let films):
            self.activityIndicator.stopAnimating()
            self.datasource = films
            self.tableView.reloadData()
        case .failed:
            self.activityIndicator.stopAnimating()
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
    static func make(allActionBuilder: @escaping () -> Observable<Films.Action>,
                     searchActionBuilder: @escaping (String) -> Observable<Films.Action>) -> FilmsViewController {
        let viewController = FilmsViewController.instantiate()
        viewController.buildAllFilmsAction = allActionBuilder
        viewController.buildSearchFilmsAction = searchActionBuilder
        return viewController
    }
}


