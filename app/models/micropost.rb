class Micropost < ApplicationRecord
  # この設定をいれることで以下のような関係を定義することができる。
  #  micropost 0..* -------- 1 user
  #  つまりユーザーがポストした文だけのMicropost情報を持つことになる。
  belongs_to :user

  # デフォルトの並び順を定義することもできる。

  default_scope -> { order(created_at: :desc) }

  # CarrierWaveに画像と関連付けたモデルを定義する。
  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size

  private

  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end

end
