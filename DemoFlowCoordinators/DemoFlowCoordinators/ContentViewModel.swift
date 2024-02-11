//
//  ContentViewModel.swift
//  DemoFlowCoordinators
//
//  Created by Sergei Kviatkovskii on 2/11/24.
//

import SwiftUI
import KVKFlowCoordinators

final class ContentCoordinator: FlowCoordinator<ContentViewModel.SheetType, ContentViewModel.LinkType, ContentViewModel.CoverType> {
    @Published var vm: ContentViewModel!
    
    init() {
        super.init()
        vm = ContentViewModel(coordinator: self)
    }
}

final class ContentViewModel: ObservableObject {
    let title = "Main View"
    
    private let coordinator: ContentCoordinator
    
    init(coordinator: ContentCoordinator) {
        self.coordinator = coordinator
    }
    
    func openFirstLink() {
        coordinator.linkType = .linkFirstWithParams("First Link View")
    }
    
    func openSecondLink() {
        coordinator.linkType = .linkSecond
    }
    
    func openThirdLink() {
        coordinator.linkType = .linkThirdWithParams("Third Link View")
    }
    
    func openSheetFirst() {
        coordinator.sheetType = .sheetFirst("Sheet First")
    }
    
    func openDetailWithGoToRoot() {
        coordinator.linkType = .linkSecondCoordinator
    }
    
    func openCoverFirst() {
        coordinator.coverType = .coverFirst
    }
}

extension ContentViewModel {
    
    enum CoverType: FlowTypeProtocol {
        case coverFirst
        
        var id: String {
            String(describing: self)
        }
    }

    enum LinkType: FlowTypeProtocol {
        case linkFirstWithParams(String)
        case linkSecond
        case linkThirdWithParams(String)
        case linkSecondCoordinator
        
        var id: String {
            String(describing: self)
        }
    }

    enum SheetType: FlowTypeProtocol {
        case sheetFirst(String)
        
        var id: String {
            String(describing: self)
        }
    }
    
}
