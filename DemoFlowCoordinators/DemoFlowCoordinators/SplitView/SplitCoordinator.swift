//
//  SplitCoordinator.swift
//  DemoFlowCoordinators
//
//  Created by Sergei Kviatkovskii on 3/3/24.
//

import Foundation
import KVKFlowCoordinators

final class SplitSideBarCoordinator: LinkCoordinator<SplitCoordinator.LinkTestType> {
    
    private let parent: DemoFlowCoordinator?
    
    init(parent: DemoFlowCoordinator? = nil) {
        self.parent = parent
    }
    
    override func popToRoot() {
        parent?.popToRoot()
    }
    
    func openLink(_ link: SplitCoordinator.LinkTestType) {
        linkType = link
    }
}

final class SplitContentCoordinator: SheetCoordinator<SplitCoordinator.SheetTestType> {
    
    func openSheet(_ sheet: SplitCoordinator.SheetTestType) {
        sheetType = sheet
    }
}

final class SplitDetailCoordinator: LinkCoordinator<SplitCoordinator.LinkTestType> {
    
    func openLink(_ link: SplitCoordinator.LinkTestType) {
        linkType = link
    }
}

struct SplitCoordinator {
    enum SheetTestType: FlowTypeProtocol {
        case sheet
        
        var pathID: String {
            String(describing: self)
        }
    }
    enum LinkTestType: FlowTypeProtocol {
        case linkSideBar, linkDetail
        
        var pathID: String {
            String(describing: self)
        }
    }
}
