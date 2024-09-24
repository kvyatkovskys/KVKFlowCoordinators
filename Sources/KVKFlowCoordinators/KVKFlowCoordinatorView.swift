//
//  KVKFlowCoordinatorView.swift
//  
//
//  Created by Sergei Kviatkovskii on 2/17/24.
//

import SwiftUI

public struct FlowCoordinatorView<T: FlowProtocol, U: View>: View {
    
    @ObservedObject private var coordinator: T
    private let content: () -> U
    
    public init(_ coordinator: T,
                @ViewBuilder content: @escaping () -> U) {
        self.coordinator = coordinator
        self.content = content
    }
    
    public var body: some View {
        // if parent coordinator has already containts `NavigationStack` no need to add the another one
        if let parent = coordinator.kvkParent, parent.canWorkWithLink {
            content()
        } else if coordinator.canWorkWithLink || coordinator.useNavigationStack {
            NavigationStack(path: $coordinator.path) {
                content()
            }
        } else {
            content()
        }
    }
}

private struct CoordinatorModifier<T: FlowProtocol>: ViewModifier {
    @ObservedObject var coordinator: T
    
    public func body(content: Content) -> some View {
        FlowCoordinatorView(coordinator) {
            content
        }
    }
}

public extension View {
    func flowCoordinator<T: FlowProtocol>(_ coordinator: T) -> some View {
        modifier(CoordinatorModifier(coordinator: coordinator))
    }
}
