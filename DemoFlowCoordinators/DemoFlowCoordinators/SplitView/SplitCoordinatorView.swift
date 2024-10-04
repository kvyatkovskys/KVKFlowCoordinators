//
//  NavigationSplitView.swift
//  DemoFlowCoordinators
//
//  Created by Sergei Kviatkovskii on 3/2/24.
//

import SwiftUI
import KVKFlowCoordinators

struct CoordinatorFullSplitView: View {
    
    @ObservedObject private var sideBarCoordinator: SplitSideBarCoordinator
    @ObservedObject private var contentCoordinator: SplitContentCoordinator
    
    init(parent: DemoFlowCoordinator? = nil) {
        sideBarCoordinator = SplitSideBarCoordinator(parent: parent)
        contentCoordinator = SplitContentCoordinator()
    }
    
    var body: some View {
        SideBarSplitView(vm: sideBarCoordinator.vm)
            .flowLink(for: SplitCoordinator.LinkTestType.self) { item in
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
            .flowSplitCoordinator(
                sideBarCoordinator: sideBarCoordinator,
                contentCoordinator: contentCoordinator,
                detailCoordinator: sideBarCoordinator.detailCoordinator,
                content: {
                    ContentSplitView(coordinator: contentCoordinator)
                },
                detail: {
                    DetailSplitView(vm: sideBarCoordinator.detailCoordinator.vm)
                        .flowLink(for: SplitCoordinator.LinkTestType.self) { item in
                            switch item {
                            case .linkDetail:
                                VStack(spacing: 30) {
                                    Text("Link View")
                                    Button("Pop to View") {
                                        sideBarCoordinator.detailCoordinator.popView()
                                    }
                                }
                            default:
                                EmptyView()
                            }
                        }
                }
            )
            .sheet(item: $contentCoordinator.sheetType) { item in
                switch item {
                case .sheet:
                    SheetView(title: "Conent Sheet View")
                }
            }
    }
}

private struct ContentSplitView: View {
    @ObservedObject var coordinator: SplitContentCoordinator
    
    var body: some View {
        VStack(spacing: 30) {
            Button("Open sheet") {
                coordinator.openSheet(.sheet)
            }
        }
        .navigationTitle("Content")
    }
}

private struct SideBarSplitView: View {
    @ObservedObject var vm: SplitSideBarVM
    
    var body: some View {
        VStack(spacing: 30) {
            List(vm.numbers, id: \.self) { number in
                Button {
                    vm.openNumber(number)
                } label: {
                    Text("Row number: \(number)")
                }
                .tint(vm.selectedNumber == number ? .gray : .black)
                .buttonStyle(.bordered)
            }
            Button("Open link") {
                vm.openLink(.linkSideBar)
            }
            Button("Pop to Root") {
                vm.popToRoot()
            }
        }
        .navigationTitle("Side Bar")
    }
}

private struct DetailSplitView: View {
    
    @ObservedObject var vm: SplitDetailVM
    
    var body: some View {
        VStack(spacing: 30) {
            if let number = vm.selectedNumber {
                Text("Selected Number: \(number)")
            }
            Button("Open Link") {
                vm.openLink(.linkDetail)
            }
        }
        .navigationTitle("Detail")
    }
}

struct CoordinatorSplitView: View {
    
    @ObservedObject private var sideBarCoordinator: SplitSideBarCoordinator
    
    init(parent: DemoFlowCoordinator) {
        sideBarCoordinator = SplitSideBarCoordinator(parent: parent)
    }
    
    var body: some View {
        SideBarSplitView(vm: sideBarCoordinator.vm)
            .flowLink(for: SplitCoordinator.LinkTestType.self) { item in
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
            .flowSplitCoordinator(
                sideBarCoordinator: sideBarCoordinator,
                detailCoordinator: sideBarCoordinator.detailCoordinator
            ) {
                DetailSplitView(vm: sideBarCoordinator.detailCoordinator.vm)
                    .flowLink(for: SplitCoordinator.LinkTestType.self) { item in
                        switch item {
                        case .linkDetail:
                            VStack(spacing: 30) {
                                Text("Link View")
                                Button("Pop to View") {
                                    sideBarCoordinator.detailCoordinator.popToRoot()
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
    CoordinatorSplitView(parent: .init())
}
