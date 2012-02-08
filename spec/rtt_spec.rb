# coding: utf-8
require "spec_helper"

class Dummy
  include Rtt
  
  attr_accessor :lang, :content
  
  def initialize(lang = "en", content = "")
    @lang    = lang
    @content = content
  end
end

describe Rtt do
  describe "preprocessing" do
    before(:each) do
      dummy = Dummy.new
      @control_1 = "Am 13.04.1899 ist es geschehen - was steht woanders. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nam cursus. Morbi ut mi. Nullam enim leo, egestas id, condimentum at, laoreet mattis, massa."
      @string    = "Am 13.04.1899 ist es geschehen – was steht woanders. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nam cursus. Morbi ut mi. Nullam enim leo, egestas id, condimentum at, laoreet mattis, massa."
      @control_2 = "Am 13.04.1899 ist es geschehen - was steht woanders. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nam cursus. Morbi ut mi. Null-am e-nim leo, egestas id, condimentum at, laoreet mattis, massa."
      @extra     = "Am 13.04.1899 ist es geschehen – was steht woanders. Lo#rem ipsum d#olor sit am%et, cons^ect$etuer adipiscing e@lit. Nam cursus. Morbi ut mi. Null-am e--nim leo, egestas id, condimentum at, laoreet mattis, massa."
      @control_3 = "Am 13.04.1899 ist es geschehen - was steht woanders. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nam cursus. Morbi ut mi. Null-am e-nim leo, egestas id, condimentum at, laoreet mattis, massa."
      @getaggt   = "Am 13.04.1899 ist es geschehen – was steht woanders. Lo#rem ipsum d#olor sit am%et, cons^ect$etuer adipiscing e@lit. Nam cursus. Morbi ut mi. Null-am e--nim leo, egestas id, condimentum at, laoreet mattis, massa."
    end

    it "should replace a string by itself" do
      tag = Dummy.new("en",@string)
      tag.preprocess
      tag.content.should == @control_1
    end

    it "should replace non alphanum caharacters within words with nothings" do
      tag = Dummy.new("en",@extra)
      tag.preprocess
      tag.content.should == @control_2
    end

    describe "preprocessing:html" do
      before(:each) do
        path = File.join(File.dirname(__FILE__), '..', 'tmp','tmp.html')
        @html_file = File.open(path)
      end

      it "should load the given html file" do
        file = @html_file.read
        tag = Dummy.new("en",file)
        tag.preprocess
        tag.content.should_not match(/<\/?[^>]*>/)
      end
    end
  end

  describe "tagging" do
    it "should find the right language dependent on input" do
      tag = Dummy.new("en","")
      tag.get_command_language.should == ("english")
    end
    
    it "should build the correct tagging command, dependend on input language" do
      tag = Dummy.new("en","")
      tag.build_tagging_command.should == ("tree-tagger-english")
    end
    
    it "should prefer utf8 over other" do
      tag = Dummy.new("de","")
      tag.build_tagging_command.should == ("tree-tagger-german-utf8")
    end
    
    describe "Output format" do
      it "should be an array as output" do
        tag = Dummy.new("de","Das ist ein Satz")
        tag.preprocess
        tag.tagging.should be_a Array
      end
      it "should have correct count" do
        tag = Dummy.new("de","Das ist ein Satz")
        verfifier = tag.content.split(" ").length
        tag.preprocess
        tag.tagging.should have(verfifier).things
      end
      
      # testing output format, means: for each word in given input gives an array
      # with: 1. input word, 2. tagging category, 3. lemma
      # could be done over output length
      it "should have correct output format" do
        tag = Dummy.new("en","Das ist ein Satz")
        tag.preprocess
        tag.tagging.first.should have(3).things
      end
    end
  end
end
