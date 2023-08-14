# Style nonexistent links differently

# frozen_string_literal: true
require 'nokogiri'

Jekyll::Hooks.register [:wiki], :post_write, priority: Jekyll::Hooks::PRIORITY_MAP[:low] do |doc|
  check_links(doc)
end

Jekyll::Hooks.register [:pages], :post_write, priority: Jekyll::Hooks::PRIORITY_MAP[:low] do |doc|
  # jekyll considers anything at the root as a page,
  # we only want to consider actual pages
  next unless doc.path.start_with?('_pages/')
  check_links(doc)
end

def check_links(doc)
  style_nonexistent_links = !!doc.site.config["style_nonexistent_links"]

  if style_nonexistent_links
    parsed_doc = Nokogiri::HTML(doc.output)
    # Get the output directory path
    output_dir = doc.site.config['destination']
    parsed_doc.css("a:not(.nonexistent-link)").each do |link|
      href = link['href']
      if href.start_with?('/') # Handle internal links
        # Construct the file path based on the full URL
        file_path = File.join(output_dir, href)
        # if File.extname(file_path).empty?
        #   file_path += ".html"
        # end
        # Check if the file exists
        if File.exist?(file_path) || File.exist?(file_path + ".html") || File.exist?(file_path + "/index.html")
          # Link points to a real page
          link['class'] = (link['class'] || '') + ' internal-link'
        else
          # Link points to a nonexistent page
          link['class'] = (link['class'] || '') + ' nonexistent-link'
          link['aria-label'] = (link['aria-label'] || '') + ' (Create new page)'
        end
      end
    end
    if doc.content != parsed_doc.to_html
      puts("Overwriting ", doc.destination(doc.site.dest))
      File.write(doc.destination(doc.site.dest), parsed_doc.to_html, :mode => 'wb')
    end
    # puts(doc.output)
  end
end
