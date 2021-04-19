![](img/logo.svg)

## Progression

Progression is the framework which helps you to automate migration process. It based on progressive migration approach.

- [Progressive migration](#progressive-migration)
	- [Problem](#problem)
	- [Solution](#solution) 
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
	- [Version file](#create-database-version-file)
	- [Migration](#migrate-persistent-store)
- [License](#license)

## Progressive migration

### Problem
If application has many database versions it becomes hard to handle a new one. Each new version will oblidge you to re-create every migration.

![](img/db1.svg)


### Solution
Soulution is progressive migration. It consists of a series of migration. And every new database version will require only one migration - from previous to the last.

![](img/db2.svg)

## Requirements

- iOS 10.0+ / macOS 10.12+ / tvOS 10.0+ / watchOS 3.0+
- Swift 5+

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding Progression as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/badretdinov/Progression.git", .upToNextMajor(from: "1.0"))
]
```

Or using `Xcode`:

- File > Swift Packages > Add Package Dependency
- Add `https://github.com/badretdinov/Progression.git`
- Select "Up to Next Major" with "1.0"


### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

```ogdl
github "badretdinov/Progression" ~> 1.0
```

### CodoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

```ruby
pod 'Progression', '~> 1.0'
```

## Usage

### Create database version file

First create database version file by inheritancing from `RawRepresentable(String)` and `DBVersion`, define `databaseName` and each db version. Note that `PDatabaseVersion` is `CaseIterable` and order of cases is very important.

Optionally you can override `migrationTypes`. First version can be empty because database won't be migrated to that version.

```swift
enum DatabaseVersion: String, PDatabaseVersion {
    static var databaseName = "Model"
    
    case version1 = "MM"
    case version2 = "MM2"
    case version3 = "MM3"
    
    var migrationTypes: [PDatabaseMigrationType] {
        switch self {
        case .version1:
            return []
        case .version2:
            return [.named("1_2")]
        case .version3:
            return [.named("2_3")]
        }
    }
}
```

Models can be combined. In this case framework will use the first successfully loaded model.

```swift
var migrationTypes: [PDatabaseMigrationType] {
	return [.automatic, .named("1_to_2"), .inferred)]
}

```

#### Migration types

There are 3 migration types:

1. Automatic. The appropriate mapping model will be loaded automatically from the bundle.
2. Named. The model will be loaded from the filename you provided. Please note that you shouldn't put extension into the filename.
3. Inferred. The model will be created as inferred.

### Migrate persistent store

And then you need to init `PMigrationManager` with your database version and call migration method.

```swift
let manager = PMigrationManager<DatabaseVersion>()

manager.migrateStoreIfNeeded(storeURL: url, bundle: Bundle.main)
//or
manager.migrate(storeURL: url, toVersion: .version3, bundle: Bundle.main)

```

Here is NSPersistentContainer container usage:

```swift
private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: DatabaseVersion. databaseName)
    let manager = PMigrationManager<DatabaseVersion>()
    
    if let first = container.persistentStoreDescriptions.first, let url = first.url {
        first.shouldMigrateStoreAutomatically = false
        first.shouldInferMappingModelAutomatically = false
        
        do {
            try manager.migrateStoreIfNeeded(storeURL: url, bundle: Bundle.main)
        } catch {
            //Handle error
        }
    }
    
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
        
    })
    return container
}()
```

## License

Progression is released under the MIT license. [See LICENSE](https://github.com/badretdinov/Progression/blob/main/LICENSE) for details.