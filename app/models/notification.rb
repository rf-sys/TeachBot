class Notification < ApplicationRecord
  belongs_to :user

  class << self
    def generate(title, text, link = nil)
      self.new(title: title, text: text, link: link)
    end
  end
end
