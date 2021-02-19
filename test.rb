  require 'net/http'
  require 'uri'
  require 'open-uri'
  require 'nokogiri'

    def item_name(url)
      html_file = URI.open(url)
      html_doc = Nokogiri::HTML(html_file)
      if url.include? 'www.youtube'
        return html_doc.at('meta[name="title"]')['content'] # works for YouTube
      else
        return html_doc.css('head title').inner_text # works for spotify and more
      # does not work for Techcrunch
      end
    end

p item_name('abc')
