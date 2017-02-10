class Lesson < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :course, touch: true

  validates :title, presence: true, length: {maximum: 50}
  validates :description, presence: true, length: {maximum: 500} # temporarily

  after_save :clean_slug_cache
  private

  def should_generate_new_friendly_id?
    title_changed?
  end

  def clean_slug_cache
    Rails.cache.delete("lesson/#{slug_was}/info")
  end
end
