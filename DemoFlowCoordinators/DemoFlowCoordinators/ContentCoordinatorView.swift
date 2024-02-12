//
//  ContentCoordinatorView.swift
//  DemoFlowCoordinators
//
//  Created by Sergei Kviatkovskii on 2/11/24.
//

import SwiftUI

struct ContentCoordinatorView: View {
    
    @StateObject private var coordinator = ContentCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ContentView(vm: coordinator.vm)
#if !os(macOS)
                .fullScreenCover(item: $coordinator.coverType, content: { (item) in
                    SheetView(title: "Cover View")
                })
#endif
                .sheet(item: $coordinator.sheetType) { (item) in
                    switch item {
                    case .sheetFirst(let title):
                        SheetView(title: title)
                    }
                }
                .navigationDestination(for: ContentViewModel.LinkType.self) { (item) in
                    switch item {
                    case .linkFirstWithParams(let title),
                            .linkThirdWithParams(let title):
                        NavigationLinkView(title: title)
                    case .linkSecond:
                        NavigationLinkView(title: "Test Second Link")
                    case .linkSecondCoordinator:
                        SecondContentCoordinatorView(coordinator: coordinator.secondContentCoordinator)
                    }
                }
        }
    }
    
}

#Preview {
    ContentCoordinatorView()
}
