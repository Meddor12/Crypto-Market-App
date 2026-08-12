//
//  ViewController.swift
//  Crypto Market App
//
//  Created by Shiddo on 12.08.2026.
//

import UIKit
import Combine


class ViewController: UIViewController {

    let viewModel = MainScreenViewModel()
    
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchData { viewState in
            switch viewState {
            case .idle: print("idle")
            case .error(let error): print("error: \(error)")
            case .loading: print("loading")
            case .loaded(let coinList): print("loaded: \(coinList)")
            }
        }
    }

}
