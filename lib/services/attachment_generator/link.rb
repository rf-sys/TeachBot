module Services
  module AttachmentGenerator
    # generate attachment link
    class Link
      def initialize(url)
        @url = url
        @uri = URI(url)
        @original_url = "#{@uri.scheme}://#{@uri.host}/"

        @title, @image, @template = nil
      end

      # @return [Object]
      def attachment
        page = Nokogiri::HTML(open(@uri))

        @id = Time.now.to_i

        @title = extract_title(page)

        @image = extract_image(page)

        @template = render_template

        attachment_json
      end

      private

      # @return [String] title of the html page
      def extract_title(page)
        page.css('head').search('title').text.strip.delete("\n")
      end

      # @return [String] first valid image url
      def extract_image(page)
        images = page.search('img[src]')

        image_url = ''

        images.each do |image|
          src = normalize_src_attr(image)
          next unless valid_image?(src)
          image_url = src
          break if image_url.present?
        end

        image_url
      end

      # check if found by url image satisfies conditions
      # @return [Bool]
      def valid_image?(src)
        image = FastImage.new(src)
        return false unless image.type
        return false unless %w[jpg png jpeg svg].include?(image.type.to_s)
        return false if image.size[0] < 100 || image.size[1] < 100
        true
      end

      # @return [String]
      def normalize_src_attr(image)
        src = image.attributes['src'].text
        # check url format
        src.prepend(@original_url) unless src =~ /\A#{URI.regexp}\z/
        src
      end

      # @return [String]
      def render_template
        ApplicationController.render(
          template: 'attachments/link',
          layout:   false,
          locals:   {
            id: @id, url: @url, title: @title, image: @image, preview: true
          }
        )
      end

      # @return [Object]
      def attachment_json
        {
          template: @template,
          data:     {
            id: @id, url: @url, title: @title, image: @image, type: 'link'
          }
        }
      end
    end
  end
end
