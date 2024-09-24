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
    private(set) var secondContentCoordinator: SecondContentCoordinator!
    
    init(parent: DemoFlowCoordinator? = nil) {
        super.init(parent: parent)
        vm = ContentViewModel(coordinator: self)
        secondContentCoordinator = SecondContentCoordinator(parent: parent, title: "Second Coordinator")
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
    
    func openLinks() {
        coordinator.linksType = [.linkFirstWithParams("First Link View"), .linkSecond]
    }
    
    func openSheetFirst(autoClose: Bool) {
        if autoClose {
            coordinator.sheetType = .sheetFirst("Auto Close Sheet")
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.coordinator.dismissSheet()
            }
        } else {
            coordinator.sheetType = .sheetFirst("Close Sheet")
        }
    }
    
    func openComplexLink() {
        coordinator.linkType = .linkSecondCoordinator2
    }
    
    func openCoverFirst() {
        coordinator.coverType = .coverFirst
    }
}

extension ContentViewModel {
    
    enum CoverType: FlowTypeProtocol {
        case coverFirst
        
        var pathID: String {
            String(describing: self)
        }
    }

    enum LinkType: FlowTypeProtocol {
        case linkFirstWithParams(String)
        case linkSecond
        case linkThirdWithParams(String)
        case linkSecondCoordinator
        case linkSecondCoordinator2
        
        var pathID: String {
            String(describing: self)
        }
    }

    enum SheetType: FlowTypeProtocol {
        case sheetFirst(String)
        
        var pathID: String {
            String(describing: self)
        }
    }
    
}
