require "awesome_print"
class Config < Thor
  include Thor::Actions

  desc "init PATH", "add TreeTagger path to module (--force replace old one)"
  method_options :force => :boolean
  def init(path)
    if options.force?
      remove
    end
    case
    # 1. check if path set
    when path
      # a) check, if it is an accessible dir
      if ::File.exists?(path)
        insert(path)
      else
        p "not an regular directory"
      end
    # 2. is env set?
    when ENV['TREETAGGERHOME']
      path = ENV['TREETAGGERHOME']
      insert(path)
    else
      puts "specify path as argument:\n"
      puts "  thor config:init /path/to/your/TreeTagger/installation/"
    end

    set_languages
  end
  
  desc "set_languages", "set installed languages"
  def set_languages
    p "setting languages"
    languages = {}
    
    lib_path = File.join(get_path, 'lib')
    Dir.entries(lib_path).each do |file|
      foos = file.split("-")
      languages[foos.first] = {utf8: foos.last.include?("utf")} unless foos.first.include?(".")
    end

    insert_into_file "lib/rtt/tt_settings.rb", after: /^  TT_HOME = (.+)\n/ do
      "  LANGUAGES = #{languages}\n"
    end

  end

  desc "get_languages", "see possible languages"
  def get_languages
    languages = []
    cmd_path = File.join(get_path, 'cmd')
    ap cmd_path
    tt_langs = File.join(cmd_path, 'tree-tagger*')
    Dir.glob(tt_langs).each do |file|
      languages << file.split("-")[2]
    end
    p languages.uniq
  end

  private
  def insert(path)
    p "insert path .."
    unless File.exists?("lib/rtt/tt_settings.rb")
      create_file "lib/rtt/tt_settings.rb" do
"module Rtt
  TT_HOME = \"#{path}\"
end"
      end
    else
      insert_into_file "lib/rtt/tt_settings.rb", after: "module Rtt\n" do
        "  TT_HOME = \"#{path}\"\n"
      end
    end
  end
  
  def remove
    p "removing old .."
    gsub_file "lib/rtt/tt_settings.rb", /^  TT_HOME = (.+)\n/ do |match|
      match = ""
    end
  end

  def get_path
    path = ""
    gsub_file "lib/rtt/tt_settings.rb", /^  TT_HOME = (.+)\n/ do |match|
      path = match
    end
    path.chomp.split(" = ").last.gsub("\"",'')
  end
end