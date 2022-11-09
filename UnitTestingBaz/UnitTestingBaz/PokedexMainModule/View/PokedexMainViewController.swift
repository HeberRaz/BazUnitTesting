//
//  TransverseSearcherViewController.swift
//  UnitTestingBaz
//
//  Created by Heber Raziel Alvarez Ruedas on 31/10/22.
//

import UIKit

final class PokedexMainViewController: UIViewController {
    
    // MARK: - Protocol properties
    
    var presenter: PokedexMainPresenterProtocol?
    var pokemonList: [PokemonCellModel] = []
    
    // MARK: - Private properties
    private var tableView: UITableView = UITableView()
    private typealias Constants = PokedexMainConstants
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.willFetchPokemons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
        setupNavigationBar()
        setup(tableView)
        registerCells()
    }
    
    // MARK: - Private methods
    
    private func setupNavigationBar() {
        title = "Pokemon"
    }
    
    private func setup(_ pokemonTableView: UITableView) {
        self.tableView = pokemonTableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.borderPadding),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.borderPadding),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.borderPadding),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.borderPadding)
        ])
    }
    
    private func registerCells() {
        tableView.register(PokedexSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: PokedexSectionHeaderView.reuseIdentifier)
        tableView.register(PokemonCell.self, forCellReuseIdentifier: PokemonCell.cellIdentifier)
    }
}

extension PokedexMainViewController: PokedexMainViewControllerProtocol {
    func reloadInformation() {
        guaranteeMainThread {
            self.tableView.reloadData()
        }
    }
    
    func fillPokemonList() {
        guard let lastPokemon: Pokemon = self.presenter?.model.last else { return }
        self.pokemonList.append(PokemonCellModel(from: lastPokemon))
        self.pokemonList = self.pokemonList.sorted { previous, next in
            return previous.id < next.id
        }
        presenter?.reloadSections()
    }
    
    private func guaranteeMainThread(_ work: @escaping () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async(execute: work)
        }
    }
}

extension PokedexMainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRowAt(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        52
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView: PokedexSectionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: PokedexSectionHeaderView.reuseIdentifier) as? PokedexSectionHeaderView else { return nil }
        headerView.setup()
        return headerView
    }
}

extension PokedexMainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count: Int = pokemonList.count
        let displayableCount: Int = count == presenter?.totalPokemonCount
        ? presenter?.totalPokemonCount ?? .zero
        : count + 20
        return displayableCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: PokemonCell = tableView.dequeueReusableCell(withIdentifier: PokemonCell.cellIdentifier, for: indexPath) as? PokemonCell else { return UITableViewCell() }
        if presenter?.isLoadingCell(for: indexPath) ?? false {
            cell.setup(with: .none)
        } else {
            let cellData: PokemonCellModel = pokemonList[indexPath.row]
            cell.setup(with: cellData)
        }
        return cell
    }
}

extension PokedexMainViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        presenter?.shouldPrefetch(at: indexPaths)
    }
}
