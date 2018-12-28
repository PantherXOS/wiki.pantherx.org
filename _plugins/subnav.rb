require "nokogiri"

class MySubnavGenerator < Jekyll::Generator
  def generate(site)
    parser = Jekyll::Converters::Markdown.new(site.config)

    site.pages.each do |page|
      if page.ext == ".md"
        doc = Nokogiri::HTML(parser.convert(page['content']))

        page.data["subnav"] = doc.css('h2').map do |h2|
          to_nav_item(page, h2).tap do |item|
            item["children"] = subheadings(h2).map { |h3| to_nav_item(page, h3) }
          end
        end
      end
    end
  end

  # Converts a heading into a hash of the info for a link
  def to_nav_item(page, heading)
    {
      "title" => heading.text,
      "url" => [page.url, heading['id']].join("#")
    }
  end

  # Returns an enumerator of all H3s "belonging" to an H2
  def subheadings(el)
    Enumerator.new do |y|
      next_el = el.next_sibling
      while next_el && next_el.name != "h2"
        if next_el.name == "h3"
          y << next_el
        end
        next_el = next_el.next_sibling
      end
    end
  end
end