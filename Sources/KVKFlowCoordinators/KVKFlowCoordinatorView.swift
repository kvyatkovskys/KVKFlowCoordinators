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
