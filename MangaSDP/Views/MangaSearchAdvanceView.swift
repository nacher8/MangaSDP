//
//  MangaSearchAdvanceView.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 16/2/26.
//

import SwiftUI

struct MangaSearchAdvanceView: View {
    @Environment(MangaSearchAdvanceViewModel.self) private var mangaSearchAdvanceViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isTitleFieldFocused: Bool
    @FocusState private var isFirstNameFieldFocused: Bool
    @FocusState private var isLastNameFieldFocused: Bool
    
    var body: some View {
        @Bindable var mangaSearchAdvanceVM = mangaSearchAdvanceViewModel
        NavigationStack {
            ZStack {
                Color.orange.opacity(0.15)
                    .ignoresSafeArea()
                
                Form {
                    Section {
                        HStack {
                            Image(systemName: "book.fill")
                                .foregroundColor(.gray)
                                .frame(width: 20)
                            
                            TextField("Enter manga title", text: $mangaSearchAdvanceVM.mangaTitle)
                                .focused($isTitleFieldFocused)
                                .textInputAutocapitalization(.words)
                                .autocorrectionDisabled()
                            
                            if !mangaSearchAdvanceVM.mangaTitle.isEmpty {
                                Button(action: {
                                    mangaSearchAdvanceVM.mangaTitle = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    } header: {
                        Text("Manga Title")
                    }
                    .listRowBackground(Color.white.opacity(0.8))
                    
                    Section {
                        HStack {
                            Image(systemName: "long.text.page.and.pencil.fill")
                                .foregroundColor(.gray)
                                .frame(width: 20)
                            
                            TextField("Enter first name author", text: $mangaSearchAdvanceVM.mangaFirstName)
                                .focused($isFirstNameFieldFocused)
                                .textInputAutocapitalization(.words)
                                .autocorrectionDisabled()
                            
                            if !mangaSearchAdvanceVM.mangaFirstName.isEmpty {
                                Button(action: {
                                    mangaSearchAdvanceVM.mangaFirstName = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    } header: {
                        Text("Author First Name")
                    }
                    .listRowBackground(Color.white.opacity(0.8))
                    
                    Section {
                        HStack {
                            Image(systemName: "long.text.page.and.pencil.fill")
                                .foregroundColor(.gray)
                                .frame(width: 20)
                            
                            TextField("Enter last name author", text: $mangaSearchAdvanceVM.mangaLastName)
                                .focused($isLastNameFieldFocused)
                                .textInputAutocapitalization(.words)
                                .autocorrectionDisabled()
                            
                            if !mangaSearchAdvanceVM.mangaLastName.isEmpty {
                                Button(action: {
                                    mangaSearchAdvanceVM.mangaLastName = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    } header: {
                        Text("Author Last Name")
                    }
                    .listRowBackground(Color.white.opacity(0.8))
                    
                    Section {
                        DisclosureGroup("Select genres") {
                            ForEach(mangaSearchAdvanceVM.genres, id: \.self) { genre in
                                HStack {
                                    Text(genre)
                                        .font(.body)
                                        .foregroundStyle(.secondary)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        mangaSearchAdvanceVM.toggleGenre(genre)
                                    }, label: {
                                        if mangaSearchAdvanceVM.selectedGenres.contains(genre) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundStyle(.yellow)
                                        } else {
                                            Image(systemName: "circle")
                                                .foregroundStyle(.gray)
                                        }
                                    })
                                }
                            }
                        }
                    } header: {
                        Text("Genres")
                    }
                    .listRowBackground(Color.white.opacity(0.8))
                    
                    Section {
                        DisclosureGroup("Select themes") {
                            ForEach(mangaSearchAdvanceVM.themes, id: \.self) { theme in
                                HStack {
                                    Text(theme)
                                        .font(.body)
                                        .foregroundStyle(.secondary)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        mangaSearchAdvanceVM.toggleTheme(theme)
                                    }, label: {
                                        if mangaSearchAdvanceVM.selectedThemes.contains(theme) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundStyle(.yellow)
                                        } else {
                                            Image(systemName: "circle")
                                                .foregroundStyle(.gray)
                                        }
                                    })
                                }
                            }
                        }
                    } header: {
                        Text("Themes")
                    }
                    .listRowBackground(Color.white.opacity(0.8))
                    
                    Section {
                        DisclosureGroup("Select demographics") {
                            ForEach(mangaSearchAdvanceVM.demographics, id: \.self) { demographic in
                                HStack {
                                    Text(demographic)
                                        .font(.body)
                                        .foregroundStyle(.secondary)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        mangaSearchAdvanceVM.toggleDemographic(demographic)
                                    }, label: {
                                        if mangaSearchAdvanceVM.selectedDemographics.contains(demographic) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundStyle(.yellow)
                                        } else {
                                            Image(systemName: "circle")
                                                .foregroundStyle(.gray)
                                        }
                                    })
                                }
                            }
                        }
                    } header: {
                        Text("Demographics")
                    }
                    .listRowBackground(Color.white.opacity(0.8))
                    
                    Section {
                        Button(action: {
                            Task {
                                try await mangaSearchAdvanceVM.searchAdvance()
                                dismiss()
                            }
                        }) {
                            HStack {
                                Spacer()
                                Image(systemName: "magnifyingglass")
                                    .font(.body)
                                Text("Search")
                                    .font(.headline)
                                Spacer()
                            }
                            .padding(.vertical, 8)
                        }
                        .disabled(!mangaSearchAdvanceVM.isSearchValid)
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.roundedRectangle(radius: 12))
                        .tint(.yellow)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                    .listSectionSpacing(.compact)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Advanced Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        mangaSearchAdvanceVM.reset()
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
                
                ToolbarItem {
                    Button(role: .close) {
                        dismiss()
                    }
                }
            }
            .onAppear {
                Task {
                    await mangaSearchAdvanceVM.loadCategories()
                }
            }
        }
    }
}

#Preview {
    MangaSearchAdvanceView()
}
