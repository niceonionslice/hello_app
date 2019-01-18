# railstutorial.jp

第10章 ユーザーの更新・表示・削除

Usersリソース用のRESTfulのうち、これmで未実装だったedit, update, index, destory アクションを加え、RESTアクションを完成を目指す。

ユーザー自身で自分のプロフィールを編集できるようにする。
さらに、自分以外にはプロフィールを変更できないようにしましょう。

10.3.5 から 続きをしましょう。
パーシャルのリファクタリング

テストをしっかり実行できていればそれだけでエンジニアとっては強力なツールである。
動作を変更することなくロジックの中身を変更することができる。
バグの修正、可読性の向上、性能向上などその恩恵は大きい。

10.4 ユーザーを削除するからスタート

ユーザを削除する機能を利用できるユーザは誰？
管理ユーザーという属性をもつユーザーを作りましょう。

 |users||
 |-|-
 |id|integer
 |name|string
 |email|string
 |email|string
 |created_at|datetime
 |updated_at|datetime
 |password_digest|string
 |remember_digest|string
 |admin|boolean

 上下左右
 ctl+F カーソルを右へ
 ctl+B カーソルを左へ
 ctl+P カーソルを上へ
 ctl+N カーソルを下へ

 ctl+A 行頭／段落先頭に移動
 ctl+E 行末／段落末に移動

 ctl+D カーソル右側の文字を削除
 ctl+H カーソル左側の文字を削除
 ctl+shift+K 行削除
