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
    
    private var coins: [Coin] = []

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()

        viewModel.fetchData { viewState in
            switch viewState {
            case .idle: print("idle")
            case .error(let error): print("error: \(error)")
            case .loading: print("loading")
            case .loaded(let coinList):
                self.coins = coinList
                print("loaded: \(coinList)")
                self.tableView.reloadData()
            }
        }
    }
    
    private func setupTableView() {
            view.addSubview(tableView)

            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])

            tableView.dataSource = self
        }

}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  coins.count //viewModel.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier,for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        let coin = coins[indexPath.row]
        cell.configure(model: coin)

        return cell
        
    }
}
