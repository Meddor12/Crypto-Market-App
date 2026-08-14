//
//  FavoriteViewController.swift
//  Crypto Market App
//
//  Created by Shiddo on 14.08.2026.
//

import Foundation
import CoreData
import UIKit

class FavoritesViewController: UIViewController {
    
    private var favorites: [Coin] = []
    
    private var context: NSManagedObjectContext {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Избранное"
        view.backgroundColor = .white
        setupTableView()
        fetchFavorites()
    }
    
    private func fetchFavorites() {
        let cdEntities = CDCoins.fetchAll(context: context)
        self.favorites = cdEntities.compactMap {
            return Coin(
                id: $0.id ?? "",
                symbol: $0.symbol ?? "",
                name: $0.name ?? "",
                image: $0.image ?? "",
                currentPrice: Double($0.price ?? "0") ?? 0,
                marketCap: Double($0.marketCap ?? "0") ?? 0
            )
        }
        
        tableView.reloadData()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        let item = self.favorites[indexPath.row]
        
        cell.configure(model: item)
        return cell
    }
    
    // удаление свайпом — раз уж мы тут, это стандартная и полезная фича
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let coinToDelete = favorites[indexPath.row]
        
        let request: NSFetchRequest<CDCoins> = CDCoins.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", coinToDelete.id as CVarArg)
        request.fetchLimit = 1
        
        do {
            if let deletableCDCoin = try context.fetch(request).first {
                context.delete(deletableCDCoin)
            }
            
            try context.save()
            
            favorites.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            print("Ошибка удаления: \(error)")
        }
    }
}

extension FavoritesViewController: UITableViewDelegate {}
