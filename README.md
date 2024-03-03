[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-orange.svg)](https://swiftpackageindex.com/kvyatkovskys/KVKFlowCoordinators)
[![License](https://img.shields.io/cocoapods/l/KVKCalendar.svg?style=flat)](https://cocoapods.org/pods/KVKFlowCoordinators)

# KVKFlowCoordinators
SwiftUI flow coordinator to control navigation in your App.

## Requirements

- iOS 16.0+, iPadOS 16.0+, MacOS 13.0+ (supports Mac Catalyst)
- Swift 5.0+

## Installation

**KVKFlowCoordinators** is available through [CocoaPods](https://cocoapods.org) or [Swift Package Manager](https://swift.org/package-manager/).

### CocoaPods
~~~bash
pod 'KVKFlowCoordinators'
~~~

[Adding Pods to an Xcode project](https://guides.cocoapods.org/using/using-cocoapods.html)

### Swift Package Manager (Xcode 12 or higher)

1. In Xcode navigate to **File** → **Swift Packages** → **Add Package Dependency...**
2. Select a project
3. Paste the repository URL (`https://github.com/kvyatkovskys/KVKFlowCoordinators`) and click **Next**.
4. For **Rules**, select **Version (Up to Next Major)** and click **Next**.
5. Click **Finish**.

[Adding Package Dependencies to Your App](https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app)

## Usage for SwiftUI
- Import `KVKFlowCoordinators`
- Create an entities with type of navigation (for ex.):
  ```swift
  enum SheetType: FlowTypeProtocol {
      case detail

      var pathID: String {
          "detail"
      }
  }
  ```
- Create a coordinator that inherits from the`FlowCoordinator` base class if you want to use:
  - `.sheet`
  - `.navigationDestination`
  - `.fullScreenCover`
- Or use a specific coordinator class:
  - `SheetCoordinator`
  - `LinkCoordinator`
  - `CoverCoordinator`
  - `SheetAndLinkCoordinator`
  - `SheetAndCoverCoordinator`
  - `LinkAndCoverCoordinator`
- Create a `CoordinatorView` -> use the `FlowCoordinatorView` or `FlowCoordinatorSplitView` view with the created coordinator inside body
  ```swift
  var body: some View {
      FlowCoordinatorView(coordinator) {
          // content
      }
  }
  
  var body: some View {
      FlowCoordinatorSplitView(sideBarCoordinator, detailCoordinator) {
          // side bar content
      } detail: {
          // detail content
      }
  }
  ```

To work with _navigation link_ use 
```swift
.navigationDestination(for: NavigationLinkType.self) { (item) in
  // content
}
// .navigationDestination(item: $item) doesn't work
```

### Navigation Link Features
- Pops all the views on the stack except the root view:
  ```swift
  func popToRoot()
  ```
- Pops the top view from the navigation stack:
  ```swift
  func popView()
  ```
- Pops views until the specified view is at the top of the navigation stack. Works only if use `coordinator.linkType`: 
  ```swift
  func popToView(_ pathID: String) -> [String]
  ```
  #### Parameter
  ##### pathID
  The `pathID` that you want to be at the top of the stack. This view must currently be on the navigation stack.
  #### Return Value
  An array containing the path link IDs that were popped from the stack.
  
##
```swift
final class ContentCoordinator: FlowCoordinator<SheetType, LinkType, CoverType> {
    @Published var vm: ContentViewModel!
    
    private(set) var secondContentCoordinator: SecondContentCoordinator!
    
    init() {
        super.init()
        vm = ContentViewModel(coordinator: self)
        secondContentCoordinator = SecondContentCoordinator(parentCoordinator: self, title: "Second Coordinator")
    }
}

struct ContentCoordinatorView: View {
    @StateObject private var coordinator = ContentCoordinator()
    
    var body: some View {
        FlowCoordinatorView(coordinator) {
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

final class ContentViewModel: ObservableObject {    
    private let coordinator: ContentCoordinator
    
    init(coordinator: ContentCoordinator) {
        self.coordinator = coordinator
    }
    
    func openFirstLink() {
        coordinator.linkType = .linkFirstWithParams("First Link View")
    }
}

struct ContentView: View {
    @ObservedObject var vm: ContentViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Button("Open Sheet") {
                vm.openSheetFirst(autoClose: false)
            }
            Button("Open Auto Close Sheet") {
                vm.openSheetFirst(autoClose: true)
            }
            Button("Open Cover") {
                vm.openCoverFirst()
            }
            Button("Open Link First") {
                vm.openFirstLink()
            }
            Button("Open Complex Btn Link") {
                vm.openComplexLink()
            }
            NavigationLink("Open Complex Nav Link",
                           value: ContentViewModel.LinkType.linkSecondCoordinator)
        }
        .padding()
    }
}
```

## Demo
https://github.com/kvyatkovskys/KVKFlowCoordinators/assets/8233076/4f4bd26b-8103-41a4-94ff-a9e25249bd02

## Author

[Sergei Kviatkovskii](https://github.com/kvyatkovskys)

## License

KVKFlowCoordinators is available under the [MIT license](https://github.com/kvyatkovskys/KVKFlowCoordinators/blob/master/LICENSE.md)
