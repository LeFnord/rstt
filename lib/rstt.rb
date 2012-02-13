# coding: utf-8
require "celluloid"
require "active_support/all"

# own dependencies
require "rstt/version"
require "rstt/preprocess"
require "rstt/tt_settings"

module Rstt
  # added celluloid for for concurrency
  include Celluloid
  mattr_accessor :lang, :content, :origin, :tagged
  
  def self.set_input(input = {lang: "", content: ""})
    if input[:lang]
      @@lang = input[:lang]
    else
      @@lang = "en"
    end
    @@content = input[:content]
  end
  
  # helpers
  def self.print
    p @@lang
    p @@content
  end
  
  # tagging stage related methods
  def self.tagging
    bar = `echo #{self.content} | #{TT_HOME}/cmd/#{build_tagging_command}`
    @@tagged = bar.split("\n").collect{|word| word.split("\t") }
  end
  
  def self.build_tagging_command
    lang = get_command_language
    if LANGUAGES[lang][:utf8]
      cmd = "tree-tagger-#{lang}-utf8"
    else
      cmd = "tree-tagger-#{lang}"
    end
    
    cmd
  end
  
  def self.get_command_language
    lang = language_codes[self.lang.to_sym]

    if lang.nil?
      raise "language not supported"
    elsif LANGUAGES[lang].nil?
      raise "language supported, but not installed"
    end
    
    lang
  end
  
  def self.preprocessing
    @@origin = @@content
    # its important, that first html tags would be stripped and then non word characters
    Preprocess.strip_html_tags(@@origin)
    Preprocess.strip_punctation_and_non_word_caracters(self.content)
  end
  
  def self.language_codes
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
  
  def self.installed_language_codes
    installed = {}
    language_codes.each do |lang|
      installed[lang.first] = lang.last unless LANGUAGES[lang.last].nil?
    end
    
    installed
  end
  
end
