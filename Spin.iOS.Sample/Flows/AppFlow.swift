//
//  AppFlow.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxFlow
import RxSwift
import Spin
import Spin_RxSwift
import UIKit

class AppFlow: Flow {
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()
    
    private let baseUrl = "swapi.co"
    
    var root: Presentable {
        return self.rootViewController
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppSteps else { return .none }
        
        switch step {
        case .films:
            return self.navigateToFilms()
        }
    }
}

extension AppFlow {
    func navigateToFilms() -> FlowContributors {
        let viewController = FilmsViewController.instantiate()
        
        // build Spin
        let allFilmsBusinessFunction = curry2Extended(function: Films.Business.all)(baseUrl)(AlamofireNetworkService())
        let allIntentToFilmsAction = curry2(function: Films.UseCase.allIntentToFilmsAction)(allFilmsBusinessFunction)
        
        Spin
            .from(function: viewController.emitIntents)
            .compose(function: allIntentToFilmsAction)
            .scan(initial: .idle, reducer: Films.reducer)
            .consume(by: viewController.interpret, on: MainScheduler.instance)
            .spin()
            .disposed(by: viewController.disposeBag)
        
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNext: viewController))
    }
}
