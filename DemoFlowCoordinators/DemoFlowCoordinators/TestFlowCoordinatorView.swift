//
//  TestFlowCoordinatorView.swift
//  DemoFlowCoordinators
//
//  Created by Sergei Kviatkovskii on 3/3/24.
//

import SwiftUI
import KVKFlowCoordinators

final class SheetCoordinatorTest: SheetCoordinator<SheetCoordinatorTestView.SheetTestType> {
    override var useNavigationStack: Bool {
        false
    }
}

final class LinkCoordinatorTest: LinkCoordinator<SheetCoordinatorTestView.LinkTestType> {}

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
    
    @StateObject var coordinator = SheetCoordinatorTest()
    
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
