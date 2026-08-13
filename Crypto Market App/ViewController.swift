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
    private let refreshControl = UIRefreshControl()
    private var coins: [Coin] = []
    
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupRefreshControl()
        loadFirstPage()
    }
    
    private func loadFirstPage() {
        viewModel.fetchNextPage { [weak self] viewState in
            self?.handle(viewState, isFirstPage: true)
        }
    }
    private func loadNextPage() {
        viewModel.fetchNextPage { [weak self] viewState in
            self?.handle(viewState, isFirstPage: false)
        }
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(
            self,
            action: #selector(refreshData),
            for: .valueChanged
        )
        
        tableView.refreshControl = refreshControl
    }
    @objc private func refreshData() {
        viewModel.reset()
        coins = []
        viewModel.fetchNextPage { [weak self] viewState in
            self?.handle(viewState, isFirstPage: true)
            if case .loaded = viewState {
                self?.refreshControl.endRefreshing()
            }
        }
    }
    private func handle(_ viewState: ViewState, isFirstPage: Bool) {
        switch viewState {
        case .idle: print("idle")
        case .error(let error): print("error: \(error)")
        case .loading: print("loading")
        case .loaded(let newCoins):
            let startIndex = coins.count
            coins.append(contentsOf: newCoins)
            
            if isFirstPage {
                tableView.reloadData()
            } else {
                let indexPaths = (startIndex..<coins.count).map { IndexPath(row: $0, section: 0) }
                tableView.insertRows(at: indexPaths, with: .none)
            }
        }
    }
    
    private func setupTableView() {
        
        view.backgroundColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            let threshold = coins.count - 5 // подгружаем чуть заранее, а не в последней строке
            if indexPath.row >= threshold {
                loadNextPage()
            }
        }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = coins[indexPath.row]
        print(item)
        let detailVC = DetailViewController(coin: item)
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
