class User < ApplicationRecord
    before_save {email.downcase!}
    validates :name, presence: true, length: {maximum: Settings.User.name.maximum}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: {maximum: Settings.User.email.maximum},
      format: {with: VALID_EMAIL_REGEX},
      uniqueness: {case_sensitive: false}
    validates :password, presence: true, length: {minimum: Settings.User.password.minimum}
    has_secure_password
end
