# coding: utf-8
require "rtt/version"
require "rtt/preprocess"
require "rtt/tt_settings"

module Rtt
  include Rtt::Preprocess
  
  def tagging
    cmd = "#{TT_HOME}/cmd"
    
    bar = `echo #{self.content} | #{cmd}/#{build_tagging_command}`
    
    tagged = bar.split("\n").collect{|word| word.split("\t") }
    
    tagged
  end
  
  def build_tagging_command
    lang = get_command_language
    if LANGUAGES[lang][:utf8]
      cmd = "tree-tagger-#{lang}-utf8"
    else
      cmd = "tree-tagger-#{lang}"
    end
    
    cmd
  end
  
  def get_command_language
    lang = language_codes[self.lang.to_sym]

    if lang.nil?
      raise "language not supported"
    elsif LANGUAGES[lang].nil?
      raise "language supported, but not installed"
    end
    
    lang
  end
  
  def preprocess
    strip_punctation_and_non_word_caracters(self.content)
    strip_html_tags(self.content)
  end
  
  def language_codes
    { bg: "bulgarian",
      nl: "dutch",
      en: "english",
      et: "estonian",
      fr: "french",
      de: "german",
      el: "greek",
      it: "italian",
      la: "latin",
      ru: "russian", 
      es: "spanish",
      sw: "swahili"
    }
  end
end
