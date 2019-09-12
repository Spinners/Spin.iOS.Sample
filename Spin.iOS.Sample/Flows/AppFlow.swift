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
        
        // build Spin
        let allFilmsBusinessFunction = curry2Extended(function: Films.Business.all)(baseUrl)(AlamofireNetworkService())
        let searchFilmsBusinessFunction = curry3(function: Films.Business.search)(baseUrl)(AlamofireNetworkService())
        
        let allFilmsAction = curry1Extended(function: Films.UseCase.allFilmsAction)(allFilmsBusinessFunction)
        let searchFilmsAction = curry2(function: Films.UseCase.searchFilmsAction)(searchFilmsBusinessFunction)
             
        let viewController = FilmsViewController.make(allActionBuilder: allFilmsAction, searchActionBuilder: searchFilmsAction)
        
        Spin
            .from(function: viewController.emitActions)
            .scan(initial: .idle, reducer: Films.reducer)
            .consume(by: viewController.interpret, on: MainScheduler.instance)
            .spin()
            .disposed(by: viewController.disposeBag)
        
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNext: viewController))
    }
}

extension Observable {
    static func merge<A>(functions: (Observable<A>) -> Observable<Element>...) -> (Observable<A>) -> Observable<Element> {
        return { (a: Observable<A>) -> Observable<Element> in
            let results: [Observable<Element>] = functions.map { $0(a) }
            return Observable<Element>.merge(results)
        }
    }
}
