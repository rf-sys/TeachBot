module Services
  module AttachmentGenerator
    class Image
      def initialize(url)
        @url = url
      end

      def attachment
        @id = Time.now.to_i
        @template = render_template

        attachment_json
      end

      private

      def render_template
        ApplicationController.render(
          template: 'attachments/image',
          layout:   false,
          locals:   {
            url: @url, id: @id, preview: true
          }
        )
      end

      def attachment_json
        {
          template: @template,
          data:     {
            id:   @id, type: 'image', url:  @url
          }
        }
      end
    end
  end
end
