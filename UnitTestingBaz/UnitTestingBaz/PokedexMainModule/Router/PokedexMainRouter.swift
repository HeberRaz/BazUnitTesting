//
//  TransverseSearcherRouter.swift
//  UnitTestingBaz
//
//  Created by Heber Raziel Alvarez Ruedas on 31/10/22.
//

import UIKit

final class PokedexMainRouter {
    // MARK: - Properties
    var view: PokedexMainViewControllerProtocol?
    var interactor: (PokedexMainInteractorInputProtocol & PokedexRemoteDataOutputProtocol)?
    var presenter: (PokedexMainPresenterProtocol & PokedexMainInteractorOutputProtocol)?
    var router: PokedexMainRouterProtocol?
    var remoteData: PokedexMainRemoteDataInputProtocol?
}

extension PokedexMainRouter: PokedexMainRouterProtocol {
    
    func createPokedexMainModule() -> UINavigationController {
        buildModuleComponents()
        linkDependencies()
        guard let viewController: UIViewController = view as? UIViewController else {
            return UINavigationController()
        }
        let navigationController: UINavigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
    
    func presentPokemonDetail(named pokemonName: String) {
        guard let viewController: UIViewController = self.view as? UIViewController else { return }
        let detailRouter = PokedexDetailRouter()
        let vc = detailRouter.createPokedexDetailModule()
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAlert(with alertModel: AlertModel, handler: @escaping () -> Void) {
        guard let viewController: UIViewController = self.view as? UIViewController else { return }
        let alert = UIAlertController(title: alertModel.title,
                                      message: alertModel.message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            handler()
        }))
        DispatchHelper.guaranteeMainThread {
            viewController.navigationController?.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Private methods
    
    private func buildModuleComponents() {
        let service: ServiceAPI = ServiceAPI(session: URLSession.shared)
        let serviceDecorator = MainQueueDispatchDecorator(service)
        view = PokedexMainViewController()
        interactor = PokedexMainInteractor()
        presenter = PokedexMainPresenter()
        remoteData = PokedexMainRemoteDataManager(service: service)
        router = self
    }
    
    private func linkDependencies() {
        view?.presenter = self.presenter
        presenter?.view = self.view
        presenter?.interactor = self.interactor
        presenter?.router = self
        interactor?.remoteData = self.remoteData
        interactor?.presenter = self.presenter
        remoteData?.interactor = self.interactor
    }
    
    private func guaranteeMainThread(_ work: @escaping () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async(execute: work)
        }
    }
}

final class MainQueueDispatchDecorator: ServiceApiProtocol {
    var session: URLSessionProtocol
    private let decorator: ServiceApiProtocol

    init(_ decorator: ServiceApiProtocol) {
        self.session = URLSession.shared
        self.decorator = decorator
    }

    func get<T:Decodable>(_ endpoint: Endpoint, callback: @escaping (Result<T, Error>) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            self.decorator.get(endpoint) { (result: Result<T, Error>) in
                self.guaranteeMainThread {
                    callback(result)
                }
            }
        }
    }

    private func guaranteeMainThread(_ work: @escaping () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async(execute: work)
        }
    }
}

struct DispatchHelper {
    static func guaranteeMainThread(_ work: @escaping () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async(execute: work)
        }
    }
}
