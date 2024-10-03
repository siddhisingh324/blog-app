class User < ApplicationRecord
  has_secure_password validations: false

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8, maximum: 15 }, on: :create
end
