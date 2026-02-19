# 📚 MangaSDP

Native iOS application to explore, filter, and manage a personal manga collection, built entirely with the latest Apple technologies.

---

## 📱 Description

**MangaSDP** is an iOS app that allows the user to:

- 📖 **Browse** a paginated manga catalogue fetched from a REST API.
- 🔍  **Filter** by genre, demographic, and theme.
- 🔎 **Advanced search** combining title, author, and multiple categories simultaneously.
- 👤 **Manage** a personal collection with the user's favourite manga.
- 📄 **View the detail** of each manga: synopsis, score, authors, volumes, chapters, status, etc.
- 🧑‍🎨 **Explore authors** and view the detail of each one with their associated works.

---

## 🛠️ Technologies used

| Technology | Usage |
|---|---|
| **SwiftUI** | Declarative user interface |
| **SwiftData** | Local data persistence |
| **Swift Concurrency** (`async`/`await`, `actor`) | Networking and concurrent operations |
| **`@Observable`** | Reactive ViewModels (Observation framework) |
| **`@ModelActor`** | Thread-safe access to SwiftData from background threads |
| **`@AppStorage`** | Lightweight persistence of pagination state |

---

## 🏛️ Architecture

The project follows an **MVVM (Model-View-ViewModel)** architecture combined with the **Repository** pattern for data access, leveraging modern Swift capabilities.

```
┌──────────────────────────────────────────────────────┐
│                        VIEW                          │
│   SwiftUI Views – render the state of the VMs        │
└───────────────────────┬──────────────────────────────┘
                        │ observes (@Observable)
┌───────────────────────▼──────────────────────────────┐
│                    VIEWMODEL                         │
│  MangaUserViewModel · MangaFilterViewModel           │
│  MangaSearchAdvanceViewModel                         │
└──────────────┬───────────────────────┬───────────────┘
               │ SwiftData             │ Network
┌──────────────▼──────────┐  ┌─────────▼──────────────┐
│      DATA LAYER         │  │    NETWORK LAYER        │
│  SwiftData (ModelContext)│  │  Network (Repository)  │
│  DataContainer (@actor) │  │  URLSession + async/await│
└─────────────────────────┘  └────────────────────────┘
```

### Main layers

- **View**: SwiftUI views that consume ViewModel state via `@Environment`.
- **ViewModel**: `@Observable` and `@MainActor` classes that orchestrate presentation logic.
- **DataContainer**: `@ModelActor` that safely handles all SwiftData read/write operations on background threads.
- **Network (Repository)**: Networking layer that encapsulates REST API calls using `async`/`await`.
- **Model**: SwiftData models (`@Model`) and network decoding DTOs.

---

## 📂 Project structure

```
MangaSDP/
│
├── System/
│   └── MangaSDPApp.swift              
│
├── DataModel/
│   ├── DataContainer.swift 
│   ├── MangaItem.swift
│   ├── MangaUser.swift
│   └── MangaCategories.swift
│
├── Model/                       
│   ├── MangaDTO.swift
│   ├── MangaItemDTO.swift
│   ├── AuthorDTO.swift
│   ├── AuthorPageDTO.swift
│   ├── MetadataDTO.swift
│   ├── ThemeDTO.swift
│   ├── GenreDTO.swift
│   ├── DemographicDTO.swift
│   └── CustomSearch.swift
│
├── Interfaz/
│   ├── URL.swift
│   ├── URLRequest.swift
│   ├── URLSession.swift
│   ├── NetworkError.swift
│   └── NetworkInteractor.swift
│
├── Repository/
│   └── NetworkRepository.swift
│
├── ViewModels/
│   ├── MangaUserViewModel.swift
│   ├── MangaFilterViewModel.swift
│   ├── MangaAuthorsViewModel.swift
│   └── MangaSearchAdvanceViewModel.swift
│
├── Views/
│   ├── MangaRootView.swift
│   ├── MainTabView.swift
│   ├── MangaView.swift
│   ├── MangaDetailView.swift
│   ├── MangaFilterView.swift
│   ├── MangaSearchAdvanceView.swift
│   ├── MangaAuthorsView.swift
│   ├── MangaAuthorsIpadView.swift
│   ├── MangaAuthorsDetailView.swift
│   ├── MangaUserView.swift
│   ├── MangaUserDetailView.swift
│   └── MangaSplashView.swift
│
├── Components/
│   ├── MangaRow.swift
│   ├── MangaImageView.swift
│   ├── DottedLine.swift
│   ├── LabeledInlineText.swift
│   ├── MangaListMainView.swift
│   ├── MangaListFilteredView.swift
│   ├── MangaListSearchAdvanceView.swift
│   ├── MangaAuthorRow.swift
│   ├── MangaUserRow.swift
│   └── Device/
│       ├── ListMainViewIphone.swift
│       ├── ListMainViewIpad.swift
│       ├── ListFilteredViewIphone.swift
│       ├── ListFilteredViewIpad.swift
│       ├── ListSearchAdvanceViewIphone.swift
│       └── ListSearchAdvanceViewIpad.swift
│
├── Enums/
│   ├── MangaImageSize.swift
│   ├── MangaFilterType.swift
│   └── MangaListState.swift
│
├── Extensions/
│   ├── String+Extension.swift
│   └── View+Extension.swift
└── Utils/
    └── Utils.swift
```

---

## 🔄 Data flow

```
App launches
    │
    ├─▶ DataContainer.hasExistingData()
    │       ├─ false ──▶ loadInitialData() ──▶ API ──▶ SwiftData
    │       └─ true  ──▶ cached data, displayed directly
    │
    └─▶ MangaView observes @Query<MangaItem>
            ├─ Main list     ──▶ MangaListMainView
            ├─ Active filter ──▶ MangaListFilteredView (via MangaFilterViewModel)
            └─ Advanced search ──▶ MangaListSearchAdvance (via MangaSearchAdvanceViewModel)
```

### Pull-to-refresh
- **Main list**: clears the cache (manga not saved in the user's collection) and reloads from the API.
- **Active filter**: re-runs the filter starting from page 1.
- **Advanced search**: repeats the search starting from page 1.

### Pagination
Loading additional pages is managed by `DataContainer` (main list) and the corresponding ViewModels (filter and advanced search), incrementing the page number and appending results to the existing list.

---

## ✅ Requirements

- **iOS 26+**
- **Xcode 26+**
- **Swift 6+**

---

## 🚀 Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/nacher8/MangaSDP.git
   ```
2. Open `MangaSDP.xcodeproj` with Xcode 16 or later.
3. Select a simulator or device running iOS 26+.
4. Press **⌘ + R** to build and run.

> No external dependencies are required. The project does not use Swift Package Manager or CocoaPods.

---

## 👤 Author

**Ignacio Hernáiz Izquierdo**  
Project developed January – February 2026 to Swif Developer Program(Apple Coding Academy).
