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
    var pathLinks: [String: Int] { get set }
    var canWorkWithLink: Bool { get }
    var cancellable: Set<AnyCancellable> { get set }
    var kvkParent: (any FlowProtocol)? { get set }
    
    func popToRoot()
    func popView()
    func popToView(_ pathID: String?)
    func pushTo(_ link: L)
    func subscribeOnLinks()
}

open class FlowBaseCoordinator<Sheet: FlowTypeProtocol, Link: FlowTypeProtocol, Cover: FlowTypeProtocol>: FlowProtocol {
    
    public typealias S = Sheet
    public typealias L = Link
    public typealias C = Cover
    
    @Published public var sheetType: Sheet?
    @Published public var linkType: Link?
    @Published public var coverType: Cover?
    @Published public var path = NavigationPath()
    
    public var canWorkWithLink: Bool {
        if Link.self == FlowEmptyType.self {
            return false
        } else {
            return true
        }
    }
    public var cancellable = Set<AnyCancellable>()
    public var kvkParent: (any FlowProtocol)?
    public var pathLinks: [String: Int] = [:]
    
    public init(parent: (any FlowProtocol)? = nil) {
        self.kvkParent = parent
        subscribeOnLinks()
    }
    
    deinit {
        removeObservers()
    }
    
    // MARK: Public-
    public func subscribeOnLinks() {
        $linkType
            .compactMap { $0 }
            .sink { [weak self] link in
                self?.proxyPushTo(link)
            }
            .store(in: &cancellable)
    }
    
    public func popToRoot() {
        if let kvkParent {
            kvkParent.path = NavigationPath()
        } else {
            path = NavigationPath()
        }
    }
    
    public func popView() {
        if let parentPath = kvkParent?.path, !parentPath.isEmpty {
            kvkParent?.path.removeLast()
        } else if !path.isEmpty {
            path.removeLast()
        }
    }
    
    public func popToView(_ pathID: String?) {
        proxyPopToView(pathID)
    }
    
    public func pushTo<L: FlowTypeProtocol>(_ link: L) {
        if let kvkParent {
            kvkParent.path.append(link)
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
        pathLinks.removeAll()
    }
    
    // MARK: Private-
    private func proxyPushTo<L: FlowTypeProtocol>(_ link: L) {
        pushTo(link)
        
        let pathLinkId = link.pathID
        var links = kvkParent?.pathLinks ?? pathLinks
        if let kvkParent {
            links[pathLinkId] = kvkParent.path.count
            kvkParent.pathLinks = links
        } else {
            links[pathLinkId] = path.count
            pathLinks = links
        }
    }
    
    private func proxyPopToView(_ pathID: String?) {
        var links = kvkParent?.pathLinks ?? pathLinks
        guard let pathID, let position = links[pathID] else { return }
        
        if let parentPath = kvkParent?.path, !parentPath.isEmpty {
            let diff = parentPath.count - position
            kvkParent?.path.removeLast(diff)
            removePathLinks(&links, position: position)
            kvkParent?.pathLinks = links
        } else if !path.isEmpty {
            let diff = path.count - position
            path.removeLast(diff)
            removePathLinks(&links, position: position)
            pathLinks = links
        }
    }
    
    private func removePathLinks(_ links: inout [String: Int], position: Int) {
        links.forEach {
            if $0.value > position {
                links.removeValue(forKey: $0.key)
            }
        }
    }
}

public protocol FlowTypeProtocol: Identifiable, Hashable {
    var pathID: String { get }
}

public extension FlowTypeProtocol {
    public var id: String {
        pathID
    }
}

/// stab for child coordinators
/// - class Coordinator: FlowCoordinator<SheetType, **FlowEmptyType**, CoverType>
public enum FlowEmptyType: FlowTypeProtocol {
    public var pathID: String {
        ""
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

/// Empty coordinator  class
open class EmptyCoordinator: FlowBaseCoordinator<FlowEmptyType, FlowEmptyType, FlowEmptyType> {}
