//
//  SecondContentViewModel.swift
//  DemoFlowCoordinators
//
//  Created by Sergei Kviatkovskii on 2/11/24.
//

import SwiftUI
import KVKFlowCoordinators

final class SecondContentCoordinator: SheetAndLinkCoordinator<SecondContentViewModel.SecondSheetLink, SecondContentViewModel.SecondDetailLink> {
    
    @Published var vm: SecondContentViewModel!
        
    init(parentCoordinator: ContentCoordinator? = nil, title: String) {
        super.init(parentFlowCoordinator: parentCoordinator)
        vm = SecondContentViewModel(coordinator: self, title: title)
    }
}

final class SecondContentViewModel: ObservableObject {
    
    let title: String
    private let coordinator: SecondContentCoordinator
    
    init(coordinator: SecondContentCoordinator, title: String) {
        self.coordinator = coordinator
        self.title = title
    }
    
    func goToBack() {
        coordinator.goToBack()
    }
    
    func openDetail() {
        coordinator.linkType = .detailLink("Second Detail View Link")
    }
    
    func openSheet() {
        coordinator.sheetType = .sheet("Detail Sheet")
    }
}

extension SecondContentViewModel {
    
    enum SecondDetailLink: FlowTypeProtocol {
        case detailLink(String)
        
        var id: String {
            String(describing: self)
        }
    }
    
    enum SecondSheetLink: FlowTypeProtocol {
        case sheet(String)
        
        var id: String {
            String(describing: self)
        }
    }
    
}
