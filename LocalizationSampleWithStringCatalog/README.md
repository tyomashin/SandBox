#  概要

多言語対応を試す。

* [Localizing and varying text with a string catalog | Apple Developer Documentation](https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog)

## 問題点

### Swift PM のマルチモジュール構成化でうまく使えない

Resources モジュールを作成し、そこで Localizable.xcstrings を作成。

普通は、ビルドすると以下の文言（ローカライズ可能文言）が自動で Localizable.xcstrings に集約される。

* SwiftUI で使用している文字列リテラルは、自動的にローカライズ可能
* String(localized:)イニシャライザを使用して、一般的なテキストをローカライズ可能にする

しかし、マルチモジュール構成だと、上記の自動集約がうまく機能しない。
尚且つ、Localizable.xcstrings とは別モジュールで SwiftUI から Localizable.xcstrings のキーを指定しても、適切な値が設定されない。
