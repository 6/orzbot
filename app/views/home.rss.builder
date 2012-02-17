xml.instruct!
xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do
    xml.title t(:app)
    xml.description t(:meta_description)
    xml.link ENV['ROOT_URL']
    xml.language I18n.locale.to_s
    for a in @animes
      xml.item do
        xml.title I18n.locale == :en ? a[:model].title_en : a[:model].title_ja
        xml.description a[:on_air_now] ? t(:currently_airing) : (a[:model].airing? ? "#{t(:episode_x, :x => a[:status][:prev_episode_number]+1)} #{t(:airs_in_x, :x => time_diff(Time.now, a[:status][:next_date])).downcase}" : t(:starts_airing_x, :x => time_diff(a[:model].start_date, Time.now)))
        xml.link "#{ENV['ROOT_URL']}#{url(:home)}"
      end
    end
  end
end
