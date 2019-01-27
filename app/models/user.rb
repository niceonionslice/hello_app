class User < ApplicationRecord
  has_many :microposts
  # データベースにはないがUserクラスには定義された属性
  attr_accessor :remember_token, :activation_token

  # このような定義もできる。
  # before_save { self.email = email.downcase }
  before_save :downcase_email
  before_create :create_activation_digest

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
              format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i},
              uniqueness: { case_sensitive: false } # 大文字と小文字を区別しない
  has_secure_password # <- が authenticateメソッドを提供している。
  # パスワードは必須。文字列は最低6文字、空白OK
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  def downcase_email
    self.email.downcase!
  end

  # 永続セッションのためにユーザをデータベースに記録する。
  def remember
    # 新しいtokenを作成
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    # digest = self.send("#{attribute}_digest")
    digest = send("#{attribute}_digest") # モデル内にあるのでselfは省略可
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # remember_digestをnullにすることで永続セッションを開放する。
  def forget
    update_attribute(:remember_digest, nil)
  end


  # 自分自身のアカウントを有効にしましょう。
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
    # update_attribute(:activated, true)
    # update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end


  class << self
    # 渡された文字列のハッシュ値を返す
    def digest(str)
      cost =
        ActiveModel::SecurePassword.min_cost ?
          BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(str, cost: cost)
    end

    # ランダムなトークンを返す
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  private

  def create_activation_digest
    # このメソッドのコールバックの目的は、トークンとそれに対応するダイジェストを割り当てるため。
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
