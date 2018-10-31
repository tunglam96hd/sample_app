class User < ApplicationRecord
  attr_accessor :remember_token
  before_save {email.downcase!}
  VALID_EMAIL_REGEX = Settings.User.email.valid
  validates :name, presence: true, length: {maximum: Settings.User.name.maximum}
  validates :email, presence: true, length: {maximum: Settings.User.email.maximum},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.User.password.minimum}
  has_secure_password
  class << self
    def User.digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute :remember_digest, nil
  end
end
