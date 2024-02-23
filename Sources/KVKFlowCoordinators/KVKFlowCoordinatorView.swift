//
//  KVKFlowCoordinatorView.swift
//  
//
//  Created by Sergei Kviatkovskii on 2/17/24.
//

import SwiftUI

public struct FlowCoordinatorView<T: FlowProtocol, U: View>: View {
    
    @ObservedObject private var coordinator: T
    private let useNavigationStack: Bool
    private let content: () -> U
    
    public init(_ coordinator: T,
                useNavigationStack: Bool = true,
                @ViewBuilder content: @escaping () -> U) {
        self.coordinator = coordinator
        self.useNavigationStack = useNavigationStack
        self.content = content
    }
    
    public var body: some View {
        // if parent coordinator has already containts `NavigationStack` no need to add the another one
        if let parent = coordinator.kvkParent, parent.canWorkWithLink {
            content()
        } else if coordinator.canWorkWithLink || useNavigationStack {
            NavigationStack(path: $coordinator.path) {
                content()
            }
        } else {
            content()
        }
    }
}

struct SheetCoordinatorTestView: View {
    enum SheetTestType: FlowTypeProtocol {
        case sheet
        
        var pathID: String {
            String(describing: self)
        }
    }
    enum LinkTestType: FlowTypeProtocol {
        case link
        
        var pathID: String {
            String(describing: self)
        }
    }
    
    @StateObject var coordinator = SheetCoordinator<SheetTestType>()
    
    var body: some View {
        FlowCoordinatorView(coordinator) {
            VStack(spacing: 30) {
                Button("Open sheet") {
                    coordinator.sheetType = .sheet
                }
                if coordinator.canWorkWithLink {
                    Button("Open link") {
                        // coordinator.linkType = .link
                    }
                }
            }
            .navigationTitle("Link Test")
            .sheet(item: $coordinator.sheetType) { item in
                switch item {
                case .sheet:
                    VStack {
                        Text("Sheet View")
                    }
                }
            }
            .navigationDestination(for: SheetCoordinatorTestView.LinkTestType.self) { (item) in
                switch item {
                case .link:
                    VStack {
                        Text("Link View")
                    }
                }
            }
        }
    }
}

#Preview("Sheet") {
    SheetCoordinatorTestView()
}
