//
//  MangaAuthorsView.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 12/2/26.
//

import SwiftUI
import SwiftData

struct MangaAuthorsView: View {
    @Environment(\.modelContext) private var context
    @Query(filter: #Predicate<Author> { $0.isFromAuthorsList == true })
    private var authors: [Author]
    
    @AppStorage("totalAuthors") private var totalAuthors: Int = 0
    
    let flexibleItems: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color.orange.opacity(0.15)
                        .ignoresSafeArea()
                    
                    List {
                        if authors.isEmpty {
                            VStack {
                                Spacer()
                                ContentUnavailableView {
                                    Label("No Authors Yet", systemImage: "long.text.page.and.pencil.fill")
                                } description: {
                                    Text("Pull down to refresh and load authors")
                                }
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, minHeight: geometry.size.height - 100)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                        } else {
                            ForEach(authors) { author in
                                NavigationLink(value: author) {
                                    MangaAuthorRow(author: author)
                                }
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                            }
                            
                            if authors.count < totalAuthors {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                    Spacer()
                                }
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .onAppear {
                                    let modelContainer = DataContainer(modelContainer: context.container)
                                    Task {
                                        do {
                                            try await modelContainer.loadNextPageAuthors()
                                        } catch {
                                            print(error)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
                .navigationTitle("Authors")
                .refreshable {
                    let modelContainer = DataContainer(modelContainer: context.container)
                    do {
                        try await modelContainer.refreshAllAuthors()
                    } catch {
                        print("Error refreshing: \(error)")
                    }
                }
            }
        }
    }
}

#Preview {
    MangaAuthorsView()
}
