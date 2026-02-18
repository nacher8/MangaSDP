//
//  MangaRootView.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 17/2/26.
//

import SwiftUI

struct MangaRootView: View {
    @State private var showSplash: Bool = true
    
    var body: some View {
        ZStack {
            if showSplash {
                MangaSplashView()
            } else {
                MainTabView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showSplash = false
                }
            }
        }
    }
}

#Preview {
    MangaRootView()
}
