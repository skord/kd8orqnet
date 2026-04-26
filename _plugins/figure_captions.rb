# Wrap markdown images that have a title attribute in <figure>/<figcaption>.
#
#   ![Alt text](/path.jpg "Caption text")
#
# becomes
#
#   <figure>
#     <img src="/path.jpg" alt="Alt text">
#     <figcaption>Caption text</figcaption>
#   </figure>
#
# Images without a title pass through unchanged.

module Jekyll
  module FigureCaptions
    PATTERN = %r{
      <p>\s*
      (<img\s[^>]*?)
      \stitle="([^"]*)"
      ([^>]*?\/?)
      >\s*
      </p>
    }mx

    def self.process(html)
      html.gsub(PATTERN) do
        before, caption, after = Regexp.last_match[1], Regexp.last_match[2], Regexp.last_match[3]
        "<figure>#{before}#{after}><figcaption>#{caption}</figcaption></figure>"
      end
    end
  end
end

Jekyll::Hooks.register [:posts, :pages, :documents], :post_render do |item|
  next unless item.respond_to?(:output) && item.output_ext == ".html"
  item.output = Jekyll::FigureCaptions.process(item.output)
end
