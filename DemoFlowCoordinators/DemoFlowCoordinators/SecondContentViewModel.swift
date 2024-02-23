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
        
    init(parent: ContentCoordinator? = nil, title: String) {
        super.init(parent: parent)
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
    
    func popView() {
        coordinator.popView()
    }
    
    func openDetail() {
        coordinator.linkType = .detailLink("Second Detail View Link")
    }
    
    func openDetailTwo() {
        coordinator.linkType = .detailLink2("Second Detail View Link 2")
    }
    
    func openSheet() {
        coordinator.sheetType = .sheet("Detail Sheet")
    }
}

extension SecondContentViewModel {
    
    enum SecondDetailLink: FlowTypeProtocol {
        case detailLink(String)
        case detailLink2(String)
        
        var pathID: String {
            String(describing: self)
        }
    }
    
    enum SecondSheetLink: FlowTypeProtocol {
        case sheet(String)
        
        var pathID: String {
            String(describing: self)
        }
    }
    
}
