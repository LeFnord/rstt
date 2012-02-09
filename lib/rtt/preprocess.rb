# coding: utf-8
module Rtt
  module Preprocess
    def self.strip_punctation_and_non_word_caracters(content)
      unless content.nil?
        content.gsub!(/[\#\%\^\$\@]{1,2}/i,'')
        content.gsub!(/(–|--)/,'-')
        content.gsub!(/\s+/,' ')
      end
    end

    def self.strip_html_tags(content)
      unless content.nil?
        content.gsub!(/<\/?[^>]*>/, "")
      end
    end
  end
end
