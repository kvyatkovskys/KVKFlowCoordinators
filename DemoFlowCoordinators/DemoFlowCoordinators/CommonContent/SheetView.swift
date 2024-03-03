//
//  SheetView.swift
//  DemoFlowCoordinators
//
//  Created by Sergei Kviatkovskii on 2/11/24.
//

import SwiftUI

struct SheetView: View {
    @Environment(\.dismiss) private var dismiss
    let title: String
    
    var body: some View {
        NavigationStack {
            Text("Hello, World!")
                .navigationTitle(title)
                .toolbar {
#if os(macOS)
                    ToolbarItem(placement: .principal) {
                        Button("Close") {
                            dismiss()
                        }
                    }
#else
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Close") {
                            dismiss()
                        }
                    }
#endif
                }
                .padding()
        }
    }
}

#Preview {
    SheetView(title: "Sheet First")
}
