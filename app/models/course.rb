class Course < ApplicationRecord
  belongs_to :author, class_name: 'User', touch: true
  has_and_belongs_to_many :subscribers, class_name: 'User'
  has_many :lessons, dependent: :destroy

  after_create :add_author_as_participant
  before_destroy :cache_cleaner
  after_update_commit :cache_cleaner

  validates :title, presence: true, length: {minimum: 6, maximum: 30}
  validates :description, presence: true, length: {minimum: 6, maximum: 255}
  validates :public, inclusion: { in: [true, false] }

  private

  def add_author_as_participant
    self.subscribers << self.author
  end

end
