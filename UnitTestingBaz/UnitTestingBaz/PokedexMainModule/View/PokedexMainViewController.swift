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
        setup(tableView)
        showLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
        setupNavigationBar()
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
        setTableViewAnchors()
        setTableViewDelegates()
    }
    
    private func setTableViewAnchors() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.borderPadding),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.borderPadding),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.borderPadding),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.borderPadding)
        ])
    }
    
    private func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
    }
    
    private func registerCells() {
        tableView.register(PokedexSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: PokedexSectionHeaderView.reuseIdentifier)
        tableView.register(PokemonCell.self, forCellReuseIdentifier: PokemonCell.cellIdentifier)
    }
}

extension PokedexMainViewController: PokedexMainViewControllerProtocol {
    func showLoader() {
        self.view.showBlurLoader()
    }
    
    func hideLoader() {
        self.view.removeBluerLoader()
    }
    
    func reloadInformation() {
        self.tableView.reloadData()
    }
    
    func fillPokemonList() {
        for pokemon in self.presenter!.model {
            self.pokemonList.append(PokemonCellModel(from: pokemon))
        }
        hideLoader()
        tableView.reloadData()
        print("--> pasó aquí con \(pokemonList.count) pokemones ya cargados")
    }
    
    private func calculateIndexPathsToReload(from newPokemons: [Pokemon]) -> [IndexPath] {
        let startIndex = newPokemons.count - newPokemons.count
        let endIndex = startIndex + newPokemons.count
        let newIndexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
        return visibleIndexPathsToReload(intersecting: newIndexPaths)
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
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
        : count + 1
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


extension UIView {
    func showBlurLoader() {
        let blurLoader = BlurLoader(frame: self.frame)
        self.addSubview(blurLoader)
    }
    
    func removeBluerLoader() {
        if let blurLoader = self.subviews.first(where: { $0 is BlurLoader }) {
            blurLoader.removeFromSuperview()
        }
    }
}

class BlurLoader: UIView {
    
    var blurEffectView: UIVisualEffectView?
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override init(frame: CGRect) {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.backgroundColor = .clear
        blurEffectView.frame = frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView = blurEffectView
        super.init(frame: frame)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        backgroundColor = .lightGray.withAlphaComponent(0.1)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blurEffectView)
        addLoader()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLoader() {
        guard let blurEffectView = blurEffectView else { return }
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        blurEffectView.contentView.addSubview(activityIndicator)
        activityIndicator.center = blurEffectView.contentView.center
        activityIndicator.color = .black
        activityIndicator.startAnimating()
    }
}
