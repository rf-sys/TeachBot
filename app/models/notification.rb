class Notification < ApplicationRecord
  belongs_to :user, touch: true

  class << self
    def generate(title, text, link = nil)
      self.new(title: title, text: text, link: link)
    end
  end
end
