//
//  DetailNavigationLinkView.swift
//  DemoFlowCoordinators
//
//  Created by Sergei Kviatkovskii on 2/11/24.
//

import SwiftUI

struct DetailNavigationLinkView: View {
    
    @ObservedObject var coordinator: SecondContentCoordinator
    
    var body: some View {
        Button("Go to Root") {
            coordinator.goToRoot()
        }
        .navigationTitle(coordinator.vm.title)
    }
}

#Preview {
    NavigationStack {
        DetailNavigationLinkView(coordinator: SecondContentCoordinator(title: "Detail Nav View View"))
    }
}
