# coding: utf-8
module Rstt
  module Preprocess
    def self.strip_html_tags(content)
      unless content.nil?
        content.gsub!(/\s*<\/?[^>]*>\s*/," ")
        content.gsub!(/&\w+;/i," ")
      end
    end

    def self.strip_punctation_and_non_word_caracters(content)
      unless content.nil?
        content.gsub!(/\b[\#\%\^\$\@\(\)✗✓=\/"']{1,2}\b/i,'')
        content.gsub!(/\s*[\#\%\^\$\@\(\)✗✓=\/"']{1,2}\s*/i,' ')
        content.gsub!(/(–|--)/,'-')
        content.gsub!(/\s+/,' ')
        content.strip!
        # content.gsub!(/(–|--)/,'-')
        # content.gsub!(/\s+/,' ')
      end
    end
  end
end


