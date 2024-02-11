//
//  NavigationLinkView.swift
//  DemoFlowCoordinators
//
//  Created by Sergei Kviatkovskii on 2/11/24.
//

import SwiftUI

struct NavigationLinkView: View {
    let title: String
    
    var body: some View {
        Text(title)
    }
}

#Preview {
    NavigationLinkView(title: "Link Detail View")
}
