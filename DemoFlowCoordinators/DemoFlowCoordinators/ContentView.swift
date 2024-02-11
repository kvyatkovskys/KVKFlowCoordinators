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
                vm.openSheetFirst()
            }
            Button("Open Cover") {
                vm.openCoverFirst()
            }
            Button("Open Link First") {
                vm.openFirstLink()
            }
            Button("Open Link Second") {
                vm.openSecondLink()
            }
            Button("Open Link Third") {
                vm.openThirdLink()
            }
            Button("Open Complex Link") {
                vm.openDetailWithGoToRoot()
            }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        ContentView(vm: .init(coordinator: ContentCoordinator()))
    }
}
