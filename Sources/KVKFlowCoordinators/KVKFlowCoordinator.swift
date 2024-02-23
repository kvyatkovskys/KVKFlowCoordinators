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
    @discardableResult
    func popToView(_ pathID: String) -> [String]
    func pushTo<T: FlowTypeProtocol>(_ link: T)
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
    
    ///Pops all the views on the stack except the root view.
    public func popToRoot() {
        if let kvkParent {
            kvkParent.path = NavigationPath()
            kvkParent.pathLinks.removeAll()
        } else {
            path = NavigationPath()
            pathLinks.removeAll()
        }
    }
    
    ///Pops the top view from the navigation stack.
    public func popView() {
        if let parentPath = kvkParent?.path, !parentPath.isEmpty {
            kvkParent?.path.removeLast()
        } else if !path.isEmpty {
            path.removeLast()
        }
    }
    
    ///Pops views until the specified view is at the top of the navigation stack.
    ///#### Parameter
    ///##### pathID
    ///The **pathID** that you want to be at the top of the stack. This view must currently be on the navigation stack.
    ///#### Return Value
    ///An array containing the path link IDs that were popped from the stack.
    @discardableResult
    public func popToView(_ pathID: String) -> [String] {
        proxyPopToView(pathID)
    }
    
    ///Pushes a view onto the receiver’s stack.
    public func pushTo<T: FlowTypeProtocol>(_ link: T) {
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
    
    private func proxyPopToView(_ pathID: String) -> [String] {
        var links = kvkParent?.pathLinks ?? pathLinks
        guard let position = links[pathID] else { return [] }
        
        var removedLinks = [String]()
        if let parentPath = kvkParent?.path, !parentPath.isEmpty {
            let diff = parentPath.count - position
            kvkParent?.path.removeLast(diff)
            removedLinks = removePathLinks(&links, position: position)
            kvkParent?.pathLinks = links
        } else if !path.isEmpty {
            let diff = path.count - position
            path.removeLast(diff)
            removedLinks = removePathLinks(&links, position: position)
            pathLinks = links
        }
        return removedLinks
    }
    
    private func removePathLinks(_ links: inout [String: Int], position: Int) -> [String] {
        var result = [String]()
        links.forEach {
            if $0.value > position {
                links.removeValue(forKey: $0.key)
                result.append($0.key)
            }
        }
        return result
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
