EventKit を使ってスケジュールを取得するためのサンプルプロジェクト。

# 概要

EventKit フレームワークは、カレンダー・リマインダーへのAPIを提供する。

* カレンダーへのアクセス
* リマインダーへのアクセス

# EventKit 使い方

## 1. 権限のリクエスト

* NSCalendarsUsageDescription: カレンダーを使う場合
   Privacy - Calendars Usage Description

* NSRemindersUsageDescription: リマインダーを使う場合
* NSContactsUsageDescription: カレンダーUI(EventKit UI)を使う場合

## 2. カレンダーの取得

サポートされているカレンダーの一覧を取得する。

```swift
let store = EKEventStore()
let calendars = store.calendars(for: .event)
```

また、デフォルトのカレンダーは以下で取得できる。

```swift
let store = EKEventStore()
let calendar = store.defaultCalendarForNewEvents
```

[calendars(for:)](https://developer.apple.com/documentation/eventkit/ekeventstore/1507128-calendars)
[defaultCalendarForNewEvents](https://developer.apple.com/documentation/eventkit/ekeventstore/1507062-defaultcalendarfornewevents)


# 参考文献

[EKEventStore](https://developer.apple.com/documentation/eventkit/ekeventstore)
[EventKitのリマインダーを試す](https://zenn.dev/usk2000/articles/919f88900de5b6)
