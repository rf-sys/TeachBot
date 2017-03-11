class Course < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  searchkick batch_size: 5

  belongs_to :author, class_name: 'User', touch: true

  # be as polymorphic
  has_many :accesses, as: :accessable

  # get users through polymorphic relationship
  has_many :participants, through: :accesses, source: :user, dependent: :destroy

  # be as polymorphic
  has_many :subscriptions, as: :subscribeable, dependent: :destroy

  # get users through polymorphic relationship
  has_many :subscribers, through: :subscriptions, source: :user, dependent: :destroy


  has_many :lessons, dependent: :destroy

  scope :public_and_published, -> do
    where(public: true, published: true)
  end

  scope :courses_with_paginate, -> (page = 1) { page(page).per(2) }

  scope :public_params, -> do
    select(:title, :description, :poster, :updated_at)
  end

  validates :title, presence: true, length: {minimum: 6, maximum: 30}
  validates :description, presence: true, length: {minimum: 6, maximum: 255}
  validates :public, inclusion: {in: [true, false]}

  validates :theme, format: {with: /\A#.{6}\z/, message: 'color is invalid'}, allow_blank: true

  after_save :clean_old_slug_cache

  after_commit :clean_recent_courses_cache

  def search_data
    {
        title: title,
        description: description
    }
  end

  def should_index?
    public? && published? # only public and published records
  end

  private

  def should_generate_new_friendly_id?
    title_changed?
  end

  def clean_recent_courses_cache
    Rails.cache.delete('courses/recent_courses')
  end

  def clean_old_slug_cache
    Rails.cache.delete("course/#{slug_was}/info")
  end
end
