require "rails_helper"

describe Video, :vcr do
  context "pcv video" do
    Given(:video) { Video::PCV_WELCOME }
    Given(:path)  { URI "https:" + video.youtube_embed_link }

    When(:result) { Net::HTTP.get path }

    Then { Nokogiri::HTML(result).css("title").text =~ /PCV Experience/ }
  end

  context "pcmo video" do
    Given(:video) { Video::PCMO_WELCOME }
    Given(:path)  { URI "https:" + video.youtube_embed_link }

    When(:result) { Net::HTTP.get path }

    Then { Nokogiri::HTML(result).css("title").text =~ /Guide for PCMOs/ }
  end
end
