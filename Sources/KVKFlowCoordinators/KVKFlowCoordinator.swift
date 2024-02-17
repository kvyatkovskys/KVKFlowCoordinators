//
//  KVKFlowCoordinator.swift
//  KVKFlowCoordinator
//
//  Created by Sergei Kviatkovskii on 2/11/24.
//

import SwiftUI
import Combine

public protocol FlowProtocol: ObservableObject {
    associatedtype S
    associatedtype L
    associatedtype C
    
    var sheetType: S? { get set }
    var linkType: L? { get set }
    var coverType: C? { get set }
    var path: NavigationPath { get set }
    var cancellable: Set<AnyCancellable> { get set }
    var parentFlowCoordinator: (any FlowProtocol)? { get set }
    
    func popToRoot()
    func popView()
    func pushTo(_ link: L)
}

extension FlowProtocol {
    
    @available(swift, obsoleted: 0.1.1, renamed: "popToRoot")
    public func goToRoot() {
        popToRoot()
    }
    
    @available(swift, obsoleted: 0.1.1, renamed: "pop")
    public func goToBack() {
        popView()
    }
    
    @available(swift, obsoleted: 0.1.1, renamed: "pushTo")
    public func pushToLink<L: FlowTypeProtocol>(_ link: L) {
        pushTo(link)
    }
    
    public func popToRoot() {
        if let parentFlowCoordinator {
            parentFlowCoordinator.path = NavigationPath()
        } else {
            path = NavigationPath()
        }
    }
    
    public func popView() {
        if let parentPath = parentFlowCoordinator?.path, !parentPath.isEmpty {
            parentFlowCoordinator?.path.removeLast()
        } else if !path.isEmpty {
            path.removeLast()
        }
    }
    
    public func pushTo<L: FlowTypeProtocol>(_ link: L) {
        if let parentFlowCoordinator {
            parentFlowCoordinator.path.append(link)
        } else {
            path.append(link)
        }
    }
    
    public func dismissSheet() {
        sheetType = nil
    }
    
    public func dismissCover() {
        coverType = nil
    }
    
    // MARK: Internal-
    func removeObservers() {
        cancellable.removeAll()
    }
}

open class FlowBaseCoordinator<Sheet: FlowTypeProtocol, Link: FlowTypeProtocol, Cover: FlowTypeProtocol>: FlowProtocol {
    
    public typealias S = Sheet
    public typealias L = Link
    public typealias C = Cover
    
    @Published public var sheetType: Sheet?
    @Published public var linkType: Link?
    @Published public var coverType: Cover?
    @Published public var path = NavigationPath()
    public var cancellable = Set<AnyCancellable>()
    public var parentFlowCoordinator: (any FlowProtocol)?
    
    public init(parentFlowCoordinator: (any FlowProtocol)? = nil) {
        self.parentFlowCoordinator = parentFlowCoordinator
        $linkType
            .compactMap { $0 }
            .sink { [weak self] link in
                self?.pushTo(link)
            }
            .store(in: &cancellable)
    }
    
    deinit {
        removeObservers()
    }
}

public protocol FlowTypeProtocol: Identifiable, Hashable {}

/// stab for child coordinators
/// - class Coordinator: FlowCoordinator<SheetType, **FlowEmptyType**, CoverType>
public enum FlowEmptyType: FlowTypeProtocol {
    public var id: Int {
        0
    }
}

/// To contol all navigation types
open class FlowCoordinator<Sheet: FlowTypeProtocol, Link: FlowTypeProtocol, Cover: FlowTypeProtocol>: FlowBaseCoordinator<Sheet, Link, Cover> {}

/// To contol sheet navigation
open class SheetCoordinator<Sheet: FlowTypeProtocol>: FlowBaseCoordinator<Sheet, FlowEmptyType, FlowEmptyType> {}

/// To contol link navigation
open class LinkCoordinator<Link: FlowTypeProtocol>: FlowBaseCoordinator<FlowEmptyType, Link, FlowEmptyType> {}

/// To contol cover navigation
open class CoverCoordinator<Cover: FlowTypeProtocol>: FlowBaseCoordinator<FlowEmptyType, FlowEmptyType, Cover> {}

/// To contol sheet and link navigation types
open class SheetAndLinkCoordinator<Sheet: FlowTypeProtocol, Link: FlowTypeProtocol>: FlowBaseCoordinator<Sheet, Link, FlowEmptyType> {}

/// To contol shent and cover navigation
open class SheetAndCoverCoordinator<Sheet: FlowTypeProtocol, Cover: FlowTypeProtocol>: FlowBaseCoordinator<Sheet, FlowEmptyType, Cover> {}

/// To contol link and cover navigation
open class LinkAndCoverCoordinator<Link: FlowTypeProtocol, Cover: FlowTypeProtocol>: FlowBaseCoordinator<FlowEmptyType, Link, Cover> {}
