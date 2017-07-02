class Post < ApplicationRecord
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy, foreign_key: :attachable_id
  accepts_nested_attributes_for :attachments

  validates :text, length: { maximum: 500 }, presence: true

  before_save :sanitize_text

  def sanitize_text
    self.text = text_sanitizer
  end

  private

  def text_sanitizer
    ActionController::Base.helpers.sanitize(text, tags: %w[a], attributes: %w[href])
  end
end
