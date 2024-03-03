//
//  KVKFlowCoordinatorSplitView.swift
//  
//
//  Created by Sergei Kviatkovskii on 3/2/24.
//

import SwiftUI

public struct FlowCoordinatorFullSplitView<C1, C2, C3, SideBar, Content, Detail>: View where C1: FlowProtocol, C2: FlowProtocol, C3: FlowProtocol, SideBar: View, Content: View, Detail: View {
    
    @Binding private var columnVisibility: NavigationSplitViewVisibility?
    @ObservedObject private var sideBarCoordinator: C1
    @ObservedObject private var contentCoordinator: C2
    @ObservedObject private var detailCoordinator: C3
    private var sideBar: SideBar
    private var content: Content
    private var detail: Detail
    
    public init(columnVisibility: Binding<NavigationSplitViewVisibility?> = .constant(nil),
                sideBarCoordinator: C1,
                contentCoordinator: C2,
                detailCoordinator: C3,
                @ViewBuilder sideBar: () -> SideBar,
                @ViewBuilder content: () -> Content,
                @ViewBuilder detail: () -> Detail) {
        _columnVisibility = columnVisibility
        self.sideBarCoordinator = sideBarCoordinator
        self.contentCoordinator = contentCoordinator
        self.detailCoordinator = detailCoordinator
        self.sideBar = sideBar()
        self.content = content()
        self.detail = detail()
    }
    
    public var body: some View {
        bodyView
    }
    
    @ViewBuilder
    private var bodyView: some View {
        if let columnVisibility {
            let value = Binding(get: { columnVisibility },
                                set: { self.columnVisibility = $0 })
            NavigationSplitView(columnVisibility: value) {
                FlowCoordinatorView(sideBarCoordinator) {
                    sideBar
                }
            } content: {
                FlowCoordinatorView(contentCoordinator) {
                    content
                }
            } detail: {
                FlowCoordinatorView(detailCoordinator) {
                    detail
                }
            }
        } else {
            NavigationSplitView {
                FlowCoordinatorView(sideBarCoordinator) {
                    sideBar
                }
            } content: {
                FlowCoordinatorView(contentCoordinator) {
                    content
                }
            } detail: {
                FlowCoordinatorView(detailCoordinator) {
                    detail
                }
            }
        }
    }
}

public struct FlowCoordinatorSplitView<C1, C3, SideBar, Detail>: View where C1: FlowProtocol, C3: FlowProtocol, SideBar: View, Detail: View {
    
    @Binding private var columnVisibility: NavigationSplitViewVisibility?
    @ObservedObject private var sideBarCoordinator: C1
    @ObservedObject private var detailCoordinator: C3
    private var sideBar: SideBar
    private var detail: Detail
    
    public init(columnVisibility: Binding<NavigationSplitViewVisibility?> = .constant(nil),
                sideBarCoordinator: C1,
                detailCoordinator: C3,
                @ViewBuilder sideBar: @escaping () -> SideBar,
                @ViewBuilder detail: @escaping () -> Detail) {
        _columnVisibility = columnVisibility
        self.sideBarCoordinator = sideBarCoordinator
        self.detailCoordinator = detailCoordinator
        self.sideBar = sideBar()
        self.detail = detail()
    }
    
    public var body: some View {
        bodyView
    }
    
    @ViewBuilder
    private var bodyView: some View {
        if let columnVisibility {
            let value = Binding(get: { columnVisibility },
                                set: { self.columnVisibility = $0 })
            NavigationSplitView(columnVisibility: value) {
                FlowCoordinatorView(sideBarCoordinator) {
                    sideBar
                }
            } detail: {
                FlowCoordinatorView(detailCoordinator) {
                    detail
                }
            }
        } else {
            NavigationSplitView {
                FlowCoordinatorView(sideBarCoordinator) {
                    sideBar
                }
            } detail: {
                FlowCoordinatorView(detailCoordinator) {
                    detail
                }
            }
        }
    }
}
