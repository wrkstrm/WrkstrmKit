# WrkstrmKit 🧰

WrkstrmKit is a Swift library that provides a set of utilities and extensions for building flexible and reusable UICollectionView-based interfaces in iOS applications.

## ✨ Features

- 🧩 Generic collection view data source
- 🎨 Customizable collection view cells
- 🔄 SwiftUI integration with UICollectionView
- 📦 Easy cell registration and dequeuing
- 🏗️ Support for supplementary views

## 🧱 Components

### CollectionViewCell

A base class for collection view cells that can hold a model and a weak reference to a delegate view controller.

### CollectionViewController

A generic view controller for managing collection views with a specific model type conforming to `CollectionViewDisplayable`.

### CollectionViewDataSource

A flexible data source for UICollectionView that handles cell configuration and supplementary views.

### CollectionViewDisplayable

A protocol that defines the requirements for models that can be displayed in a collection view.

### HostingCollectionViewCell

A collection view cell that can host SwiftUI views, allowing for seamless integration of SwiftUI content in UICollectionView-based interfaces.

### UICollectionView Extensions

- `add(_:)`: Adds a registrar to register cell classes and nibs.
- `register(nib:)` and `register(classes:)`: Convenience methods for registering multiple cell types.
- `dequeueReusableCell(_:for:)`: Type-safe cell dequeuing.

## 🚀 Usage

1. Create a model that conforms to `CollectionViewDisplayable`.
2. Implement custom collection view cells as needed.
3. Use `CollectionViewController` or create your own controller that uses `CollectionViewDataSource`.
4. Configure your data source and set it to your collection view.

## 💻 Example

```swift
class MyModel: CollectionViewDisplayable {
    // Implement required methods
}

class MyViewController: CollectionViewController<MyModel> {
    override func viewDidLoad() {
        super.viewDidLoad()
        displayableModel = MyModel()
    }
}
```
## 🏷️ Release Names

Each release is nicknamed after a UI-kit component and a matching animal, underscoring WrkstrmKit's goal of making interfaces easier to build. 

## 📋 Requirements

- 📱 iOS 13.0+
- 🏎️ Swift 5.0+
