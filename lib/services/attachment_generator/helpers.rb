module Services
  module AttachmentGenerator
    # class, that helps work with attachments
    class Helpers < Generator
      # @return [Object]
      def attachment_type
        return nil unless @url

        net = Net::HTTP.get_response(URI(@url))
        content_type = net['Content-Type']

        # generate link attachment if provided resource - html page
        return 'link' if content_type.include?('text/html')

        # generate image attachment if provided resource - image
        return 'image' if ([content_type] & @available_image_formats).any?

        nil
      end
    end
  end
end