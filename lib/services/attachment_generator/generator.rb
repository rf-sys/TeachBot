module Services
  module AttachmentGenerator
    # entry point for attachment data
    class Generator
      def initialize(url)
        @url = url
        @available_image_formats = %w[image/jpeg image/png image/bmp]
      end

      # returns attachment data
      # @return [Object]
      def attachment
        net = Net::HTTP.get_response(URI(@url))
        content_type = net['Content-Type']

        # generate link attachment if provided resource - html page
        if content_type.include?('text/html')
          return Services::AttachmentGenerator::Link.new(@url).attachment
        end

        # generate image attachment if provided resource - image
        if ([content_type] & @available_image_formats).any?
          return Services::AttachmentGenerator::Image.new(@url).attachment
        end

        {}
      end
    end
  end
end
