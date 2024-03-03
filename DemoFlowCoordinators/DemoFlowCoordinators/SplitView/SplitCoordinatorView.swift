//
//  NavigationSplitView.swift
//  DemoFlowCoordinators
//
//  Created by Sergei Kviatkovskii on 3/2/24.
//

import SwiftUI
import KVKFlowCoordinators

struct CoordinatorFullSplitView: View {
    
    @StateObject private var sideBarCoordinator: SplitSideBarCoordinator
    @StateObject private var contentCoordinator: SplitContentCoordinator
    @StateObject private var detailCoordinator: SplitDetailCoordinator
    
    init(parent: DemoFlowCoordinator? = nil) {
        _sideBarCoordinator = StateObject(wrappedValue: SplitSideBarCoordinator(parent: parent))
        _contentCoordinator = StateObject(wrappedValue: SplitContentCoordinator())
        _detailCoordinator = StateObject(wrappedValue: SplitDetailCoordinator())
    }
    
    var body: some View {
        FlowCoordinatorFullSplitView(sideBarCoordinator, contentCoordinator, detailCoordinator) {
            VStack(spacing: 30) {
                Button("Open link") {
                    sideBarCoordinator.openLink(.linkSideBar)
                }
                Button("Pop to Root") {
                    sideBarCoordinator.popToRoot()
                }
            }
            .navigationTitle("Side Bar")
            .navigationDestination(for: SplitCoordinator.LinkTestType.self) { item in
                switch item {
                case .linkSideBar:
                    VStack(spacing: 30) {
                        Text("Link View")
                        Button("Pop View") {
                            sideBarCoordinator.popView()
                        }
                    }
                default:
                    EmptyView()
                }
            }
        } content: {
            VStack(spacing: 30) {
                Button("Open sheet") {
                    contentCoordinator.openSheet(.sheet)
                }
            }
            .navigationTitle("Content")
        } detail: {
            VStack(spacing: 30) {
                Button("Open Link") {
                    detailCoordinator.openLink(.linkDetail)
                }
            }
            .navigationTitle("Detail")
            .navigationDestination(for: SplitCoordinator.LinkTestType.self) { item in
                switch item {
                case .linkDetail:
                    VStack(spacing: 30) {
                        Text("Link View")
                        Button("Pop to View") {
                            detailCoordinator.popToRoot()
                        }
                    }
                default:
                    EmptyView()
                }
            }
        }
        .sheet(item: $contentCoordinator.sheetType) { item in
            switch item {
            case .sheet:
                SheetView(title: "Conent Sheet View")
            }
        }
    }
}

struct CoordinatorSplitView: View {
    
    @StateObject private var sideBarCoordinator: SplitSideBarCoordinator
    @StateObject private var detailCoordinator: SplitDetailCoordinator
    
    init(parent: DemoFlowCoordinator? = nil) {
        _sideBarCoordinator = StateObject(wrappedValue: SplitSideBarCoordinator(parent: parent))
        _detailCoordinator = StateObject(wrappedValue: SplitDetailCoordinator())
    }
    
    var body: some View {
        FlowCoordinatorSplitView(sideBarCoordinator, detailCoordinator) {
            VStack(spacing: 30) {
                Text("Side Bar")
                Button("Open Link") {
                    sideBarCoordinator.openLink(.linkSideBar)
                }
            }
            .navigationTitle("Side Bar")
            .navigationDestination(for: SplitCoordinator.LinkTestType.self) { item in
                switch item {
                case .linkSideBar:
                    VStack(spacing: 30) {
                        Text("Link View")
                        Button("Pop View") {
                            sideBarCoordinator.popView()
                        }
                    }
                default:
                    EmptyView()
                }
            }
        } detail: {
            VStack(spacing: 30) {
                Text("detail")
                Button("Open Link") {
                    detailCoordinator.openLink(.linkDetail)
                }
            }
            .navigationTitle("Detail")
            .navigationDestination(for: SplitCoordinator.LinkTestType.self) { item in
                switch item {
                case .linkDetail:
                    VStack(spacing: 30) {
                        Text("Link View")
                        Button("Pop to View") {
                            detailCoordinator.popToRoot()
                        }
                    }
                default:
                    EmptyView()
                }
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview("Full Split View", traits: .landscapeLeft) {
    CoordinatorFullSplitView()
}

@available(iOS 17.0, *)
#Preview("Split View", traits: .landscapeLeft) {
    CoordinatorSplitView()
}
