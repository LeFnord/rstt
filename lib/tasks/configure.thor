#!/usr/bin/env ruby
require "thor"

class Configure < Thor
  include Thor::Actions

  desc "init PATH", "add TreeTagger path to module (--force replace old one)"
  # method_options :force => :boolean
  # method_options :required
  def init(path)
    if options.force?
      remove
    end
    case
    # 1. check if path set
    when path
      # a) check, if it is an accessible dir
      if ::Dir.exists?(path)
        insert(path)
        set_languages
      else
        puts "not an regular directory"
      end
    # 2. is env set?
    when ENV['TREETAGGERHOME']
      path = ENV['TREETAGGERHOME']
      insert(path)
      set_languages
    else
      puts "specify path as argument:\n"
      puts "  thor config:init /path/to/your/TreeTagger/installation/"
    end
    
  end
  
  desc "get_languages", "see possible languages"
  def get_languages
    languages = []
    get_files_of_dir do |file|
      languages << file.split("-")[2] if file.include?("tree-tagger")
    end
    
    languages.uniq
  end
  
  private
  # desc "set_languages", "set installed languages"
  def set_languages
    puts "setting languages .."
    languages = {}
    
    lib_path = File.join(get_path, 'lib')
    Dir.entries(lib_path).each do |file|
      foos = file.split("-")
      languages[foos.first] = {utf8: foos.last.include?("utf")} unless foos.first.include?(".")
    end
    
    insert_into_file settings_path, after: /^  TT_HOME = (.+)\n/ do
      "  LANGUAGES = #{languages}\n"
    end
    
  end
  
  def insert(path)
    puts "insert path .."
    insert_into_file settings_path, after: "module Rstt\n" do
      "  TT_HOME = \"#{path}\"\n"
    end
  end
  
  def remove
    puts "removing old .."
    gsub_file settings_path, /^  TT_HOME = (.+)\n/ do |match|
      match = ""
    end
  end

  def get_path
    path = ""
    gsub_file settings_path, /^  TT_HOME = (.+)\n/ do |match|
      path = match
    end
    path.chomp.split(" = ").last.gsub("\"",'')
  end
  
  def get_files_of_dir(dir = "cmd", pattern = "tree-tagger*")
    cmd_path = File.join(get_path, dir, pattern)
    Dir.glob(cmd_path).each do |file|
      yield file
    end
  end
  
  def settings_path
    File.join(File.dirname(__FILE__), '..','rstt','tt_settings.rb')
  end
end

Configure.start