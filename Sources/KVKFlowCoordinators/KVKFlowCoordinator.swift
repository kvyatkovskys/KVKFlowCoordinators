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
    var lastActiveLink: String? { get set }
    var canWorkWithLink: Bool { get }
    var kvkParent: (any FlowProtocol)? { get set }
    var useNavigationStack: Bool { get }
    
    func popToRoot()
    func popView()
    @discardableResult
    func popToView(_ pathID: String) -> [String]
}

open class FlowBaseCoordinator<Sheet: FlowTypeProtocol,
                               Link: FlowTypeProtocol,
                               Cover: FlowTypeProtocol>: FlowProtocol {
    
    public typealias S = Sheet
    public typealias L = Link
    public typealias C = Cover
    
    @Published public var sheetType: Sheet?
    @Published public var linkType: Link? {
        didSet {
            if let linkType {
                proxyPushTo(linkType)
            }
        }
    }
    @Published public var coverType: Cover?
    @Published public var path = NavigationPath()
    
    public var canWorkWithLink: Bool {
        Link.self != FlowEmptyType.self
    }
    
    @available(*, deprecated, message: "This property is disabled and not used any more.")
    public var kvkCancellable = Set<AnyCancellable>()
    
    public var kvkParent: (any FlowProtocol)?
    public var pathLinks: [String: Int] = [:]
    public var lastActiveLink: String?
    open var useNavigationStack: Bool {
        true
    }
    
    public init(parent: (any FlowProtocol)? = nil) {
        self.kvkParent = parent
    }
    
    deinit {
        removeObservers()
    }
    
    // MARK: Public-
    @available(swift, obsoleted: 0.2.1, message: "This function is disabled and not used any more.")
    open func subscribeOnLinks() {}
    
    ///Pops all the views on the stack except the root view.
    open func popToRoot() {
        if let kvkParent {
            kvkParent.path = NavigationPath()
            kvkParent.pathLinks.removeAll()
            kvkParent.lastActiveLink = nil
        } else {
            path = NavigationPath()
            pathLinks.removeAll()
            lastActiveLink = nil
        }
    }
    
    ///Pops the top view from the navigation stack.
    open func popView() {
        if let parentPath = kvkParent?.path, !parentPath.isEmpty {
            kvkParent?.path.removeLast()
            if let lastActiveLink = kvkParent?.lastActiveLink {
                kvkParent?.pathLinks.removeValue(forKey: lastActiveLink)
            }
        } else if !path.isEmpty {
            path.removeLast()
            if let lastActiveLink = lastActiveLink {
                pathLinks.removeValue(forKey: lastActiveLink)
            }
        }
    }
    
    ///Pops views until the specified view is at the top of the navigation stack. Works only if use `func pushTo(_ link:)`.
    ///#### Parameter
    ///##### pathID
    ///The **pathID** that you want to be at the top of the stack. This view must currently be on the navigation stack.
    ///#### Return Value
    ///An array containing the path link IDs that were popped from the stack.
    @discardableResult
    open func popToView(_ pathID: String) -> [String] {
        proxyPopToView(pathID)
    }
    
    @available(*, deprecated, message: "Please use the `linkType` property instead this function.")
    ///Pushes a view onto the receiver’s stack.
    public func pushTo<T: FlowTypeProtocol>(_ link: T) {
        proxyPushTo(link)
    }
    
    open func dismissSheet() {
        sheetType = nil
    }
    
    open func dismissCover() {
        coverType = nil
    }

    // MARK: Internal-
    func removeObservers() {
        kvkCancellable.removeAll()
        pathLinks.removeAll()
    }
    
    // MARK: Private-
    private func proxyPushTo(_ link: some FlowTypeProtocol) {
        var links: [String: Int]
        if let kvkParent {
            kvkParent.path.append(link)
            links = kvkParent.pathLinks
        } else {
            path.append(link)
            links = pathLinks
        }
        
        let pathLinkId = link.pathID
        if let kvkParent {
            links[pathLinkId] = kvkParent.path.count
            kvkParent.pathLinks = links
            kvkParent.lastActiveLink = pathLinkId
        } else {
            links[pathLinkId] = path.count
            pathLinks = links
            lastActiveLink = pathLinkId
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
            kvkParent?.lastActiveLink = pathID
        } else if !path.isEmpty {
            let diff = path.count - position
            path.removeLast(diff)
            removedLinks = removePathLinks(&links, position: position)
            pathLinks = links
            lastActiveLink = pathID
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
    var id: String {
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
