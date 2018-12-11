module UsersHelper

  # 引数で与えられたユーザーのGravatar画像を返す
  # オプション引数を利用すると引数をハッシュで定義する必要がある。
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://s.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
