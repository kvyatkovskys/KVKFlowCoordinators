//
//  SecondContentCoordinatorView.swift
//  DemoFlowCoordinators
//
//  Created by Sergei Kviatkovskii on 2/11/24.
//

import SwiftUI

struct SecondContentCoordinatorView: View {
    
    @ObservedObject var coordinator: SecondContentCoordinator
    
    var body: some View {
        SecondContentView(vm: coordinator.vm)
            .sheet(item: $coordinator.sheetType) { item in
                switch item {
                case .sheet(let title):
                    SheetView(title: title)
                }
            }
            .navigationDestination(for: SecondContentViewModel.SecondDetailLink.self) { (item) in
                switch item {
                case .detailLink:
                    DetailNavigationLinkView(coordinator: coordinator)
                }
            }
    }
}

struct SecondContentCoordinatorPreview: View {
    @StateObject var coordinator = SecondContentCoordinator(title: "Second Detail View")
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            SecondContentCoordinatorView(coordinator: coordinator)
        }
    }
}
 
#Preview("Coordinator") {
    SecondContentCoordinatorPreview()
}

struct SecondContentView: View {
    
    @ObservedObject var vm: SecondContentViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Button("Go to Back") {
                vm.goToBack()
            }
            Button("Open Detail") {
                vm.openDetail()
            }
            Button("Open Sheet") {
                vm.openSheet()
            }
        }
        .navigationTitle(vm.title)
    }
    
}
