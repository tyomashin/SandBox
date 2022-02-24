# 概要

Swift Package と、それを利用するプロジェクトのワークスペース。

* SwiftPMPackageSample ... パッケージ
* SwiftPackageUseSample ... パッケージを利用する

# 要点： パッケージの作成

## 初期化

以下のコマンドを叩くことで、パッケージが自動生成される

```bash
$ swift package init --name StringTransform --type library
```

## ライブラリをXcodeで開く

以下のコマンドで Xcode が自動で開く

```bash
$ open Package.swift
```

* 「Package.swift」がルートにある場合、それは Swift Package であると認識される。

## パッケージの編集

* 機能ごとにパッケージ化する
* Package.swift を編集してパッケージを増やしていく

```swift
// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// Package.swift
// StringTransform, Hoge をパッケージとして定義

let package = Package(
    name: "StringTransform",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "StringTransform",
            targets: ["StringTransform"]
        ),
        
        .library(name: "Hoge", targets: ["Hoge"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "StringTransform", dependencies: []
        ),
        .testTarget(
            name: "StringTransformTests", dependencies: ["StringTransform"]
        ),
        
        .target(name: "Hoge", dependencies: [])
    ]
)

```

## 参考文献

[Swift Packagesでライブラリを自作する方法](https://qiita.com/uhooi/items/2f36b85f5f41cbd35189)



## TODO

* サードパーティー製のライブラリをパッケージ内で使えるかどうか



# 要点： パッケージの利用

## XCWorkspace で管理

* 機能をパッケージ側で作成するため、project ファイルが更新されなくなる -> コンフリクトが起きなくなる



## 参考文献

[.xcworkspace と Swift Package を活用して XcodeGen 等に頼らずともほぼコンフリクトしないプロジェクト設計](https://zenn.dev/treastrain/articles/e5a3911228b250)
