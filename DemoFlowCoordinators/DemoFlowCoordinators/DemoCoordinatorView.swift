//
//  DemoCoordinatorView.swift
//  DemoFlowCoordinators
//
//  Created by Sergei Kviatkovskii on 3/2/24.
//

import SwiftUI
import KVKFlowCoordinators

struct DemoCoordinatorView: View {
    @StateObject private var coordinator = DemoFlowCoordinator()
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom != .phone {
            fullBodyView
                .flowCoordinator(coordinator)
        } else {
            commonView
                .flowCoordinator(coordinator)
        }
    }
    
    private var fullBodyView: some View {
        VStack(spacing: 30) {
            Button("Full Split View") {
                coordinator.openLink(.fullSplit)
            }
            Button("Split View") {
                coordinator.openLink(.split)
            }
            Button("Common View") {
                coordinator.openLink(.usual)
            }
        }
        .navigationTitle("Demo Coordinator")
#if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
        .navigationDestination(for: DemoFlowCoordinator.LinkType.self) { item in
            switch item {
            case .fullSplit:
                CoordinatorFullSplitView(parent: coordinator)
            case .split:
                CoordinatorSplitView(parent: coordinator)
            case .usual:
                commonView
            }
        }
    }
    
    private var commonView: some View {
        ContentCoordinatorView(coordinator: coordinator.commonCoordinator)
    }
}

#Preview {
    DemoCoordinatorView()
}
