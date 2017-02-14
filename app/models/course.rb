class Course < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

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

  scope :where_public, -> { where(:public => true) }

  scope :where_published, -> { where(:published => true) }

  scope :courses_with_paginate, -> (page = 1) { page(page).per(2) }

  validates :title, presence: true, length: {minimum: 6, maximum: 30}
  validates :description, presence: true, length: {minimum: 6, maximum: 255}
  validates :public, inclusion: {in: [true, false]}

  validates :theme, format: {with: /\A#.{6}\z/, message: 'color is invalid'}, allow_blank: true

  after_save :clean_old_slug_cache, :clean_recent_courses_cache

  before_commit :clean_cache_by_slug

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

  def clean_cache_by_slug
    Rails.cache.delete("course/#{friendly_id}/info")
  end
end
