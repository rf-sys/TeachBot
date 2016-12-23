class Chat < ApplicationRecord
  has_and_belongs_to_many :user
  has_many :messages
end
