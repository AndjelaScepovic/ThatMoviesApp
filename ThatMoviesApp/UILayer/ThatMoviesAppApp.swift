//
//  ThatMoviesAppApp.swift
//  ThatMoviesApp
//
//  Created by Anđela Šćepović on 6.4.23..
//

import SwiftUI

@main
struct ThatMoviesAppApp: App {
    let dependencyContainer = AppDependenciesContainer()
    
    var body: some Scene {
        WindowGroup {
            MoviesAppView(dependencies: dependencyContainer)
            MovieDetailsView(dependencies: dependencyContainer)
        }
    }
}
