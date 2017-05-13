class Attachment < ApplicationRecord
  self.inheritance_column = :attachment_type

  belongs_to :attachable, polymorphic: true, optional: true

  attr_accessor :title, :type, :url, :image

  validates :url, presence: true
  validates :type, presence: true, inclusion: {
    in:      %w(image link),
    message: '%{value} is not a valid attachment type'
  }

  validates :title, presence: true, if: :link?

  before_create :create_link_template, if: :link?
  before_create :create_image_template, if: :image?

  def create_link_template
    self.template = ApplicationController.render(
      template: 'attachments/link',
      layout:   false,
      locals:   {
        id: Time.now.to_i, url: @url, title: @title, image: @image, preview: false
      }
    )
  end

  def create_image_template
    self.template = ApplicationController.render(
      template: 'attachments/image',
      layout:   false,
      locals:   {
        id: Time.now.to_i, url: @url, preview: false
      }
    )
  end

  private

  def link?
    attachment_type ||= Services::AttachmentGenerator::Helpers.new(@url).attachment_type
    attachment_type == 'link'
  end

  def image?
    attachment_type ||= Services::AttachmentGenerator::Helpers.new(@url).attachment_type
    attachment_type == 'image'
  end
end
