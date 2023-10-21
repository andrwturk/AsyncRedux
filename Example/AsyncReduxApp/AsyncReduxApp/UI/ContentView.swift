//
//  ContentView.swift
//  AsyncReduxApp
//
//  Created by Andrii Turkin on 21.10.23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ChatView(presenter: ChatPresenter())
    }
}

#Preview {
    ContentView()
}
