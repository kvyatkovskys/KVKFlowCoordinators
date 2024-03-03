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
        VStack(spacing: 30) {
            Button("Go to Root") {
                coordinator.popToRoot()
            }
            Button("Open Detail Two") {
                coordinator.vm.openDetailTwo()
            }
        }
        .navigationTitle("Detail View")
    }
}

#Preview {
    NavigationStack {
        DetailNavigationLinkView(coordinator: SecondContentCoordinator(title: "Detail Nav View View"))
    }
}
