class Access < ApplicationRecord
  belongs_to :user
  belongs_to :accessable, polymorphic: true
end
