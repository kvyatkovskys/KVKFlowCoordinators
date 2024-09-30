//
//  KVKFlowCoordinatorSplitView.swift
//  
//
//  Created by Sergei Kviatkovskii on 3/2/24.
//

import SwiftUI

public struct FlowCoordinatorSplitView<C1, C2, C3, SideBar, Content, Detail>: View where C1: FlowProtocol, C2: FlowProtocol, C3: FlowProtocol, SideBar: View, Content: View, Detail: View {
    
    @Binding private var columnVisibility: NavigationSplitViewVisibility?
    @ObservedObject private var sideBarCoordinator: C1
    @ObservedObject private var contentCoordinator: C2
    @ObservedObject private var detailCoordinator: C3
    private var sideBar: SideBar
    private var content: Content
    private var detail: Detail
    
    public init(columnVisibility: Binding<NavigationSplitViewVisibility?> = .constant(nil),
                sideBarCoordinator: C1,
                contentCoordinator: C2 = EmptyCoordinator(),
                detailCoordinator: C3,
                @ViewBuilder sideBar: () -> SideBar,
                @ViewBuilder content: () -> Content = { EmptyView() },
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
            getSplitViewWith(columnVisibility: value)
        } else {
            getSplitView()
        }
    }
    
    @ViewBuilder
    private func getSplitViewWith(columnVisibility: Binding<NavigationSplitViewVisibility>) -> some View {
        if Content.self == EmptyView.self {
            NavigationSplitView(columnVisibility: columnVisibility) {
                sideBar
                    .flowCoordinator(sideBarCoordinator)
            } detail: {
                detail
                    .flowCoordinator(detailCoordinator)
            }
        } else {
            NavigationSplitView(columnVisibility: columnVisibility) {
                sideBar
                    .flowCoordinator(sideBarCoordinator)
            } content: {
                content
                    .flowCoordinator(contentCoordinator)
            } detail: {
                detail
                    .flowCoordinator(detailCoordinator)
            }
        }
    }
    
    @ViewBuilder
    private func getSplitView() -> some View {
        if Content.self == EmptyView.self {
            NavigationSplitView {
                sideBar
                    .flowCoordinator(sideBarCoordinator)
            } detail: {
                detail
                    .flowCoordinator(detailCoordinator)
            }
        } else {
            NavigationSplitView {
                sideBar
                    .flowCoordinator(sideBarCoordinator)
            } content: {
                content
                    .flowCoordinator(contentCoordinator)
            } detail: {
                detail
                    .flowCoordinator(detailCoordinator)
            }
        }
    }
}

private struct CoordinatorModifier<C1, C2, C3, ContentBody, Detail>: ViewModifier where C1: FlowProtocol, C2: FlowProtocol, C3: FlowProtocol, ContentBody: View, Detail: View {
    @Binding private var columnVisibility: NavigationSplitViewVisibility?
    @ObservedObject private var sideBarCoordinator: C1
    @ObservedObject private var contentCoordinator: C2
    @ObservedObject private var detailCoordinator: C3
    private var contentBody: ContentBody
    private var detail: Detail
    
    public init(columnVisibility: Binding<NavigationSplitViewVisibility?> = .constant(nil),
                sideBarCoordinator: C1,
                contentCoordinator: C2 = EmptyCoordinator(),
                detailCoordinator: C3,
                @ViewBuilder contentBody: () -> ContentBody = { EmptyView() },
                @ViewBuilder detail: () -> Detail) {
        _columnVisibility = columnVisibility
        self.sideBarCoordinator = sideBarCoordinator
        self.contentCoordinator = contentCoordinator
        self.detailCoordinator = detailCoordinator
        self.contentBody = contentBody()
        self.detail = detail()
    }
    
    public func body(content: Content) -> some View {
        FlowCoordinatorSplitView(
            columnVisibility: $columnVisibility,
            sideBarCoordinator: sideBarCoordinator,
            contentCoordinator: contentCoordinator,
            detailCoordinator: detailCoordinator
        ) {
            content
        } content: {
            contentBody
        } detail: {
            detail
        }
    }
}

public extension View {
    func flowSplitCoordinator<C1, C2, C3, Content, Detail>(
        columnVisibility: Binding<NavigationSplitViewVisibility?> = .constant(nil),
        sideBarCoordinator: C1,
        contentCoordinator: C2 = EmptyCoordinator(),
        detailCoordinator: C3,
        @ViewBuilder content: () -> Content = { EmptyView() },
        @ViewBuilder detail: () -> Detail
    ) -> some View where C1: FlowProtocol, C2: FlowProtocol, C3: FlowProtocol, Content: View, Detail: View {
        modifier(
            CoordinatorModifier(
                columnVisibility: columnVisibility,
                sideBarCoordinator: sideBarCoordinator,
                contentCoordinator: contentCoordinator,
                detailCoordinator: detailCoordinator,
                contentBody: content,
                detail: detail
            )
        )
    }
}
