xml.instruct!
xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do
    xml.title "orzbot"
    xml.description "orzbot is a live anime airing schedule."
    xml.link ENV['ROOT_URL']
    for a in @animes
      xml.item do
        xml.title I18n.locale == :en ? a[:model].title_en : a[:model].title_ja
        xml.description a[:on_air_now] ? "Currently airing" : (a[:model].airing? ? "Episode #{a[:status][:prev_episode_number]+1} airs in #{time_diff(Time.now, a[:status][:next_date])}" : "Starts airing in #{time_diff(a[:model].start_date, Time.now)}")
        xml.link "#{ENV['ROOT_URL']}#{url(:home)}"
      end
    end
  end
end
