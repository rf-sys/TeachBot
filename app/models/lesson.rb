class Lesson < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :course, touch: true

  validates :title, presence: true, length: {maximum: 50}
  validates :description, presence: true, length: {maximum: 255} # temporarily
  validates :content, presence: true, length: {maximum: 5000}

  private

  def should_generate_new_friendly_id?
    title_changed?
  end
end
