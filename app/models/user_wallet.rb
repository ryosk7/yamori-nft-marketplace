class UserWallet < ApplicationRecord
  validates :address, presence: true, uniqueness: true
end
