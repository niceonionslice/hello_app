class Micropost < ApplicationRecord
  # この設定をいれることで以下のような関係を定義することができる。
  #  micropost 0..* -------- 1 user
  #  つまりユーザーがポストした文だけのMicropost情報を持つことになる。
  belongs_to :user

  # デフォルトの並び順を定義することもできる。

  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
