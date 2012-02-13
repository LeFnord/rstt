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
  
  desc "set_languages", "set installed languages"
  def set_languages
    puts "setting languages .."
    languages = {}
    
    lib_path = File.join(get_path, 'lib')
    Dir.entries(lib_path).each do |file|
      foos = file.split("-")
      languages[foos.first] = {utf8: foos.last.include?("utf")} unless foos.first.include?(".")
    end

    insert_into_file "lib/rstt/tt_settings.rb", after: /^  TT_HOME = (.+)\n/ do
      "  LANGUAGES = #{languages}\n"
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
  
  # desc "get_workflows", "get installed workflows"
  # def get_workflows
  #   puts "get workflow commands from command files"
  #   tree_tagger_scripts = []
  #   get_files_of_dir do |file|
  #     tree_tagger_scripts << file
  #   end
  #   
  #   tree_tagger_scripts.each do |file|
  #     p "_____________"
  #     p file
  #     File.open(file).readlines.each do |line|
  #       p line
  #     end
  #     p "\n"
  #   end
  # end
  
  private
  def insert(path)
    puts "insert path .."
    unless File.exists?("lib/rstt/tt_settings.rb")
      create_file "lib/rstt/tt_settings.rb" do
"module Rstt
  TT_HOME = \"#{path}\"
end"
      end
    else
      insert_into_file "lib/rstt/tt_settings.rb", after: "module Rstt\n" do
        "  TT_HOME = \"#{path}\"\n"
      end
    end
    
    insert_require
  end
  
  def remove
    puts "removing old .."
    gsub_file "lib/rstt/tt_settings.rb", /^  TT_HOME = (.+)\n/ do |match|
      match = ""
    end
    
    remove_require
  end

  def get_path
    path = ""
    gsub_file "lib/rstt/tt_settings.rb", /^  TT_HOME = (.+)\n/ do |match|
      path = match
    end
    path.chomp.split(" = ").last.gsub("\"",'')
  end
  
  def get_files_of_dir(dir = "cmd", pattern = "tree-tagger*")
    cmd_path = File.join(get_path, dir, pattern)
    Dir.glob(cmd_path).each do |file|
      yield file
    end
    # Dir.glob(tt_files).each do |file|
    #   p file
    #   yield file
    # end
    
    # Dir.entries(cmd_path).each do |file|
    #   yield file
    # end
  end
  
  def insert_require
    insert_into_file "lib/rstt.rb", after: "require \"rstt/preprocess\"\n" do
      "require \"rstt/tt_settings\"\n"
    end
  end
  
  def remove_require
    gsub_file "lib/rstt.rb", "require \"rstt/tt_settings\"" do |match|
      match = ""
    end
  end
end