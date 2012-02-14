xml.instruct!
xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do
    xml.title "orzbot"
    xml.description "orzbot is a live anime airing schedule."
    xml.link ENV['ROOT_URL']
    for a in @animes
      xml.item do
        xml.title I18n.locale == :en ? a.title_en : a.title_ja
        xml.description "TODO description (episode #...)"
        xml.pubDate a.created_at.to_s(:rfc822)
        xml.link "#{ENV['ROOT_URL']}#{url(:home)}"
      end
    end
  end
end
