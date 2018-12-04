# Ruby on Rails チュートリアルのサンプルアプリケーション

これは、次の教材で作られたサンプルアプリケーションです。


## Model Tables

Userのデータモデルのスケッチ
rails generateから生成されたUserデータモデル

|Users|Type|
|-|-
|id|integer
|name|string
|email|string
|created_at|datetime
|updated_at|datetime

### 検索方法

```Ruby
>> User.find_by email: "mhartl@exsample.com"
=> #<User id: 1, name: "Michael Hartl", email: "mhartl@exsample.com", created_at: "2018-12-04 15:29:47", updated_at: "2018-12-04 15:29:47">
```

6.2.2から
