//
//  DetailNavigationLinkView2.swift
//  DemoFlowCoordinators
//
//  Created by Sergei Kviatkovskii on 2/23/24.
//

import SwiftUI

struct DetailNavigationLinkView2: View {
    @ObservedObject var coordinator: SecondContentCoordinator
    
    var body: some View {
        VStack(spacing: 30) {
            Button("Go to Second View") {
                coordinator.popToView(ContentViewModel.LinkType.linkSecondCoordinator2.pathID)
            }
            Button("Go to Root") {
                coordinator.popToRoot()
            }
        }
        .navigationTitle("Detail View Two")
    }
}

#Preview {
    NavigationStack {
        DetailNavigationLinkView2(coordinator: SecondContentCoordinator(title: "Detail Nav View View2"))
    }
}
