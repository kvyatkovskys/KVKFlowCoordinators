//
//  ContentCoordinatorView.swift
//  DemoFlowCoordinators
//
//  Created by Sergei Kviatkovskii on 2/11/24.
//

import SwiftUI
import KVKFlowCoordinators

struct ContentCoordinatorView: View {
    @ObservedObject var coordinator: ContentCoordinator
    
    var body: some View {
        bodyView
            .flowCoordinator(coordinator)
            .flowLink(type: ContentViewModel.LinkType.self) { item in
                switch item {
                case .linkFirstWithParams(let title),
                        .linkThirdWithParams(let title):
                    NavigationLinkView(title: title)
                case .linkSecond:
                    NavigationLinkView(title: "Test Second Link")
                case .linkSecondCoordinator:
                    SecondContentCoordinatorView(coordinator: coordinator.secondContentCoordinator)
                case .linkSecondCoordinator2:
                    SecondContentCoordinatorView(coordinator: coordinator.secondContentCoordinator)
                }
            }
    }
    
    private var bodyView: some View {
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
    }
    
}

#Preview {
    ContentCoordinatorView(coordinator: .init())
}
