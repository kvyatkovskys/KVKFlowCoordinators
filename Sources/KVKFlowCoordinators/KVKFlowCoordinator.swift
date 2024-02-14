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
    func pushTo(_ link: any FlowTypeProtocol)
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
    public func pushToLink(_ link: any FlowTypeProtocol) {
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
    
    public func pushTo(_ link: any FlowTypeProtocol) {
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
}

public protocol FlowTypeProtocol: Identifiable, Hashable {}

/// stab for child coordinators
/// - class Coordinator: FlowCoordinator<SheetType, **FlowEmptyType**, CoverType>
public struct FlowEmptyType: FlowTypeProtocol {
    public var id: Int {
        0
    }
}

open class FlowCoordinator<Sheet: FlowTypeProtocol, Link: FlowTypeProtocol, Cover: FlowTypeProtocol>: FlowProtocol {
    public typealias S = Sheet
    public typealias N = Link
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
        cancellable.removeAll()
    }
}

open class SheetCoordinator<Sheet: FlowTypeProtocol>: FlowProtocol {
    public typealias S = Sheet
    public typealias N = FlowEmptyType
    public typealias C = FlowEmptyType
    
    @Published public var sheetType: Sheet?
    @Published public var linkType: FlowEmptyType?
    @Published public var coverType: FlowEmptyType?
    @Published public var path = NavigationPath()
    public var cancellable = Set<AnyCancellable>()
    public var parentFlowCoordinator: (any FlowProtocol)?
    
    public init(parentFlowCoordinator: (any FlowProtocol)? = nil) {
        self.parentFlowCoordinator = parentFlowCoordinator
    }
}

open class LinkCoordinator<Link: FlowTypeProtocol>: FlowProtocol {
    public typealias S = FlowEmptyType
    public typealias N = Link
    public typealias C = FlowEmptyType
    
    @Published public var sheetType: FlowEmptyType?
    @Published public var linkType: Link?
    @Published public var coverType: FlowEmptyType?
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
        cancellable.removeAll()
    }
}

open class CoverCoordinator<Cover: FlowTypeProtocol>: FlowProtocol {
    public typealias S = FlowEmptyType
    public typealias N = FlowEmptyType
    public typealias C = Cover
    
    @Published public var sheetType: FlowEmptyType?
    @Published public var linkType: FlowEmptyType?
    @Published public var coverType: Cover?
    @Published public var path = NavigationPath()
    public var cancellable = Set<AnyCancellable>()
    public var parentFlowCoordinator: (any FlowProtocol)?
    
    public init(parentFlowCoordinator: (any FlowProtocol)? = nil) {
        self.parentFlowCoordinator = parentFlowCoordinator
    }
}

open class SheetAndLinkCoordinator<Sheet: FlowTypeProtocol, Link: FlowTypeProtocol>: FlowProtocol {
    public typealias S = Sheet
    public typealias N = Link
    public typealias C = FlowEmptyType
    
    @Published public var sheetType: Sheet?
    @Published public var linkType: Link?
    @Published public var coverType: FlowEmptyType?
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
        cancellable.removeAll()
    }
}

open class SheetAndCoverCoordinator<Sheet: FlowTypeProtocol, Cover: FlowTypeProtocol>: FlowProtocol {
    public typealias S = Sheet
    public typealias N = FlowEmptyType
    public typealias C = Cover
    
    @Published public var sheetType: Sheet?
    @Published public var linkType: FlowEmptyType?
    @Published public var coverType: Cover?
    @Published public var path = NavigationPath()
    public var cancellable = Set<AnyCancellable>()
    public var parentFlowCoordinator: (any FlowProtocol)?
}

open class LinkAndCoverCoordinator<Link: FlowTypeProtocol, Cover: FlowTypeProtocol>: FlowProtocol {
    public typealias S = FlowEmptyType
    public typealias N = Link
    public typealias C = Cover
    
    @Published public var sheetType: FlowEmptyType?
    @Published public var linkType: Link?
    @Published public var coverType: Cover?
    @Published public var path = NavigationPath()
    public var cancellable = Set<AnyCancellable>()
    public var parentFlowCoordinator: (any FlowProtocol)?
    
    public init() {
        $linkType
            .compactMap { $0 }
            .sink { [weak self] link in
                self?.pushTo(link)
            }
            .store(in: &cancellable)
    }
    
    deinit {
        cancellable.removeAll()
    }
}
