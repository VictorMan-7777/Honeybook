class User < ApplicationRecord
  has_secure_password
  has_many :clients, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  before_validation { email&.downcase! }
end
