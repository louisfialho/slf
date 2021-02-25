  require 'net/http'
  require 'uri'
  require 'open-uri'
  require 'nokogiri'

    def item_name(url)
      html_file = URI.open(url)
      html_doc = Nokogiri::HTML(html_file, nil, Encoding::UTF_8.to_s)
      if url.include? 'www.youtube'
        item_name = html_doc.at('meta[name="title"]')['content'] # works for YouTube
      else
        item_name = html_doc.css('head title').inner_text # works for spotify and more
      # does not work for Techcrunch
      end
      return item_name.split.map(&:capitalize).join(' ') # caps each word
    rescue
      "No name found"
    end

p item_name('https://youtu.be/01AGm0ZA4-E')
