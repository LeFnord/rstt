# coding: utf-8
# used for: mattr_accessor
require "active_support/all"
require "celluloid"

# own dependencies
require "rstt/version"
require "rstt/preprocess"
require "rstt/tt_settings"

module Rstt
  # added celluloid for for concurrency
  include Celluloid
  mattr_accessor :lang, :content, :origin, :tagged, :sentences, :tags
  
  def self.set_input(input = {lang: "", content: ""})
    if input[:lang]
      @@lang = input[:lang]
    else
      @@lang = "en"
    end
    @@content = input[:content]
  end
  
  # tagging stage related methods
  def self.tagging
    bar = `echo #{self.content} | #{TT_HOME}/cmd/#{build_tagging_command}`
    # @@tagged = bar.split("\n").collect{|word| word.split("\t") }
    @@tagged = bar.split("\n").collect do |word|
      metrik = word.split("\t")
      # use singular attribute names
      {word: metrik[0], tag: metrik[1], stem: metrik[2]}
    end
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
    Preprocess.strip_html_tags(self.content)
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
  
  # output and processing helpers
  def self.print
    p @@lang
    p @@content
  end
  
  # done: (2012-03-06) 2012-02-25: work with `method_missing?`: DRY
  # methods are plural @@tagged keys
  %w(words tags stems).each do |meth|
    self.define_singleton_method(meth) do
      foo = []
      @@tagged.each{ |tag| foo << tag[meth.singularize.to_sym] }
      foo
    end
  end
end
