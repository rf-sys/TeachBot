class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :subscribeable, polymorphic: true, counter_cache: true, touch: true
end
