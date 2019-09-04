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

    let steps = PublishRelay<Step>()
    let intentsRelay = PublishRelay<FilmsIntent>()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.intentsRelay.accept(.all)
    }
}

extension FilmsViewController {
    func emitIntents() -> Observable<FilmsIntent> {
        return self.intentsRelay.asObservable()
    }
}

extension FilmsViewController {
    func interpret(state: FilmsState) -> Void {
        print(state)
    }
}


