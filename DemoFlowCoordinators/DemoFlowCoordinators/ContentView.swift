//
//  ContentView.swift
//  DemoFlowCoordinators
//
//  Created by Sergei Kviatkovskii on 2/11/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vm: ContentViewModel
    
    var body: some View {
       bodyView
            .navigationTitle(vm.title)
    }
    
    private var bodyView: some View {
        VStack(spacing: 30) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("Open Sheet") {
                vm.openSheetFirst(autoClose: false)
            }
            Button("Open Auto Close Sheet") {
                vm.openSheetFirst(autoClose: true)
            }
            Button("Open Cover") {
                vm.openCoverFirst()
            }
            Button("Open Link") {
                vm.openFirstLink()
            }
            Button("Complex Btn Link") {
                vm.openComplexLink()
            }
            NavigationLink("Complex Nav Link",
                           value: ContentViewModel.LinkType.linkSecondCoordinator)
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        ContentView(vm: .init(coordinator: ContentCoordinator()))
    }
}
