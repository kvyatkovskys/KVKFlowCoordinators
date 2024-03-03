//
//  DemoFlowCoordinator.swift
//  DemoFlowCoordinators
//
//  Created by Sergei Kviatkovskii on 3/2/24.
//

import Foundation
import KVKFlowCoordinators

final class DemoFlowCoordinator: LinkCoordinator<DemoFlowCoordinator.LinkType> {
    
    private(set) var commonCoordinator: ContentCoordinator!
    
    init() {
        super.init()
        commonCoordinator = ContentCoordinator(parent: self)
    }
    
    func openLink(_ link: DemoFlowCoordinator.LinkType) {
        linkType = link
    }
    
}

extension DemoFlowCoordinator {
    
    enum LinkType: String, FlowTypeProtocol {
        case fullSplit, split, usual
        
        var pathID: String {
            rawValue
        }
    }
    
}
