class Lesson < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  searchkick batch_size: 5

  scope :search_import, -> { includes(:course) }

  belongs_to :course, touch: true

  scope :belongs_to_public_and_published_courses, -> do
    includes(:course).where(courses: { public: true, published: true })
  end

  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :content, presence: true, length: { maximum: 5000 }

  def search_data
    {
        title: title,
        description: description,
        content: content
    }
  end

  def should_index?
    course.public? && course.published?
  end

  private

  def should_generate_new_friendly_id?
    title_changed?
  end
end
