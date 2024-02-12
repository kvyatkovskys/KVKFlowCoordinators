[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-orange.svg)](https://swiftpackageindex.com/kvyatkovskys/KVKFlowCoordinators)
[![License](https://img.shields.io/cocoapods/l/KVKCalendar.svg?style=flat)](https://cocoapods.org/pods/KVKFlowCoordinators)


# KVKFlowCoordinators
SwiftUI flow coordinator to control navigation in your App.

## Requirements

- iOS 16.0+, iPadOS 16.0+, MacOS 13.0+ (supports Mac Catalyst)
- Swift 5.0+

## Installation

### Swift Package Manager (Xcode 12 or higher)

1. In Xcode navigate to **File** → **Swift Packages** → **Add Package Dependency...**
2. Select a project
3. Paste the repository URL (`https://github.com/kvyatkovskys/KVKFlowCoordinators`) and click **Next**.
4. For **Rules**, select **Version (Up to Next Major)** and click **Next**.
5. Click **Finish**.

[Adding Package Dependencies to Your App](https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app)

## Usage for SwiftUI
- Import `KVKFlowCoordinators`.
- Create an entities with type of navigation (for ex. `enum SheetType: FlowTypeProtocol`).
- Create a coordinator that inherits from the`FlowCoordinator` base class if you want to use `.sheet`, `.navigationDestination`, `.fullScreenCover`. Or use a specific coordinator class `SheetCoordinator, LinkCoordinator, CoverCoordinator, SheetAndLinkCoordinator, SheetAndCoverCoordinator, LinkAndCoverCoordinator`.
- Create a `ViewModel` if you need.
- Create a `CoordinatorView` with the created coordinator.


To work with navigationLink use `.navigationDestination(for: NavigationLinkType.self)`, `.navigationDestination(item: $item)` and `NavigationLink(:)` doesn't work.


```swift
final class ContentCoordinator: FlowCoordinator<ContentViewModel.SheetType, ContentViewModel.LinkType, ContentViewModel.CoverType> {
    @Published var vm: ContentViewModel!
    
    private(set) var secondContentCoordinator: SecondContentCoordinator!
    
    init() {
        super.init()
        vm = ContentViewModel(coordinator: self)
        secondContentCoordinator = SecondContentCoordinator(parentCoordinator: self, title: "Second Coordinator")
    }
}

final class ContentViewModel: ObservableObject {    
    private let coordinator: ContentCoordinator
    
    init(coordinator: ContentCoordinator) {
        self.coordinator = coordinator
    }
    
    func openFirstLink() {
        coordinator.linkType = .linkFirstWithParams("First Link View")
    }
}

struct ContentCoordinatorView: View {
    
    @StateObject private var coordinator = ContentCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ContentView(vm: coordinator.vm)
                .fullScreenCover(item: $coordinator.coverType, content: { (item) in
                    SheetView(title: "Cover View")
                })
                .sheet(item: $coordinator.sheetType) { (item) in
                    switch item {
                    case .sheetFirst(let title):
                        SheetView(title: title)
                    }
                }
                .navigationDestination(for: NavigationLinkType.self) { (item) in
                    switch item {
                    case .linkFirstWithParams(let title):
                        NavigationLinkView(title: title)
                    case .linkSecond:
                        NavigationLinkView(title: "Test Second Link")
                    case .linkSecondCoordinator:
                        SecondContentCoordinatorView(coordinator: coordinator.secondContentCoordinator)
                    }
                }
        }
    }
    
}
```

## Author

[Sergei Kviatkovskii](https://github.com/kvyatkovskys)

## License

KVKCalendar is available under the [MIT license](https://github.com/kvyatkovskys/KVKFlowCoordinators/blob/master/LICENSE.md)
