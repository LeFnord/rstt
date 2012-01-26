class Config < Thor
  include Thor::Actions
  
  desc "init PATH", "add TreeTagger path to module (--force replace old one)"
  method_options :force => :boolean
  def init(path)
    if options.force?
      remove
    end
    case
    # 1. check it path set
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
      puts "set TreeTagger home in your environment, by adding this line in your 'bashrc' or '.profile':\n"
      puts "  export TREETAGGERHOME='/path/to/your/TreeTagger/installation'\n"
      puts "or, specify it as argument:\n"
      puts "  rake rtt:config path=/path/to/your/TreeTagger/installation"
    end
  end
  
  private
  def insert(path)
    p "insert path .."
    insert_into_file "lib/rtt.rb", after: "module Rtt\n" do
      "  TT_HOME = \"#{path}\"\n"
    end
  end
  
  def remove
    p "removing old .."
    gsub_file "lib/rtt.rb", /^  TT_HOME = (.+)\n/ do |match|
      match = ""
    end
  end
end