class User < ApplicationRecord
  has_many :microposts
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
              format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i},
              uniqueness: { case_sensitive: false } # 大文字と小文字を区別しない
end
