# モジュールは、関連したメソッドをまとめる方法の１つで、
# includeメソッドを使ってモジュールを読み込むことができます。
# (ミックスイン(mixed in)とも呼ぶ)

# 単なるRubyのコードを書くのであれば、モジュールを作成するたびに明示的に読み込んで使うのが普通ですが、Railsでは自動的にヘルパーモジュールを読み込んでくれるので、include行をわざわざ書く必要がありません。つまり、このfull_titleメソッドは自動的にすべてのビューで利用できるようになっている、ということです。

module ApplicationHelper

  # ページごとの完全なタイトルを返す。
  def full_title(page_title = '')
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
end
