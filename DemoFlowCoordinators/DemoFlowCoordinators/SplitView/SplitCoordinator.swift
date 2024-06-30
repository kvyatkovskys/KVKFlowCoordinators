//
//  SplitCoordinator.swift
//  DemoFlowCoordinators
//
//  Created by Sergei Kviatkovskii on 3/3/24.
//

import Foundation
import KVKFlowCoordinators

final class SplitSideBarCoordinator: LinkCoordinator<SplitCoordinator.LinkTestType> {
    @Published var vm: SplitSideBarVM!
    @Published var detailCoordinator = SplitDetailCoordinator()
    private let parent: DemoFlowCoordinator?
    
    init(parent: DemoFlowCoordinator? = nil) {
        self.parent = parent
        super.init()
        vm = SplitSideBarVM(coordinator: self)
    }
    
    override func popToRoot() {
        parent?.popToRoot()
    }
        
    func openLink(_ link: SplitCoordinator.LinkTestType) {
        linkType = link
    }
    
    func openNumber(_ number: Int) {
        detailCoordinator.openDetailNumber(number)
    }
}

final class SplitSideBarVM: ObservableObject {
    let numbers: Range<Int> = 0..<10
    @Published var selectedNumber: Int?
    
    private(set) var coordinator: SplitSideBarCoordinator
    
    init(coordinator: SplitSideBarCoordinator) {
        self.coordinator = coordinator
    }
    
    func popToRoot() {
        coordinator.popToRoot()
    }
    
    func openLink(_ link: SplitCoordinator.LinkTestType) {
        coordinator.openLink(link)
    }
    
    func openNumber(_ number: Int) {
        selectedNumber = number
        coordinator.openNumber(number)
    }
}

final class SplitContentCoordinator: SheetCoordinator<SplitCoordinator.SheetTestType> {
    
    func openSheet(_ sheet: SplitCoordinator.SheetTestType) {
        sheetType = sheet
    }
}

final class SplitDetailCoordinator: LinkCoordinator<SplitCoordinator.LinkTestType> {
    @Published var vm: SplitDetailVM!
    
    init() {
        super.init()
        vm = SplitDetailVM(coordinator: self)
    }
    
    func openDetailNumber(_ number: Int) {
        vm.setNumber(number)
    }
}

final class SplitDetailVM: ObservableObject {
    @Published var selectedNumber: Int?
    
    private let coordinator: SplitDetailCoordinator
    
    init(coordinator: SplitDetailCoordinator) {
        self.coordinator = coordinator
    }
    
    func openLink(_ link: SplitCoordinator.LinkTestType) {
        coordinator.linkType = link
    }
    
    func setNumber(_ numner: Int) {
        selectedNumber = numner
        if coordinator.linkType != nil {
            coordinator.popView()
        }
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
