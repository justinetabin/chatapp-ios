//
//  DependencyWorker.swift
//  ChatApp
//
//  Created by Justine Tabin on 7/6/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

protocol WorkerFactory: class {
    
}

protocol ViewControllerFactory: class {
    func makeLoginScene() -> LoginViewController
}

class DependencyWorker { }

extension DependencyWorker: WorkerFactory { }

extension DependencyWorker: ViewControllerFactory {
    func makeLoginScene() -> LoginViewController {
        return LoginViewController(factory: self, viewModel: LoginViewModel())
    }
}
