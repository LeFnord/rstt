# coding: utf-8
require "spec_helper"

describe Rstt do
  describe "module variables" do
    describe "responds to .." do
      it "should respond to :lang" do
        Rstt.respond_to?(:lang).should be_true
      end
    
      it "should respond to :content" do
        Rstt.respond_to?(:content).should be_true
      end
      
      it "should respond to :origin" do
        Rstt.respond_to?(:origin).should be_true
      end
      
      it "should respond to :tagged" do
        Rstt.respond_to?(:tagged).should be_true
      end    
    end # responds to ..
    
    describe "getting" do
      it "should print both" do
        Rstt.set_input lang: "de", content: "Das ist ein einfacher Dummy Satz."
        Rstt.print.should be_true
      end
    end
    
    describe "setting" do
      before(:each) do
        @input = {lang: "de", content: "Das ist ein einfacher Dummy Satz."}
      end
      
      it "should set both by :set_input " do
        Rstt.set_input @input
        Rstt.lang.should == @input[:lang]
        Rstt.content.should == @input[:content]
      end
    end # setting
  end # module variables
  
  describe "tagging stages" do
    before(:each) do
      @input = {lang: "de", content: "Das ist ein einfacher Dummy Satz."}
    end
    
    it "should pos tagging on given input data" do
      Rstt.set_input @input
      Rstt.tagging
    end
    
    it "origin should be content after preprocessing" do
      Rstt.set_input @input
      Rstt.preprocessing
      Rstt.origin.should == @input[:content]
    end
    
    describe "language finding and command building" do
      it "should find the right language dependent on input" do
        Rstt.set_input lang: "en", content: ""
        Rstt.get_command_language.should == ("english")
      end
    
      it "should raise an exception if language not supported" do
        Rstt.set_input lang: "xy", content: ""
        expect {Rstt.get_command_language}.to raise_error
      end
    
      it "should raise an exception if language not installed" do
        Rstt.set_input lang: "ru", content: ""
        expect {Rstt.get_command_language}.to raise_error
      
      end
    
      it "should build the correct tagging command, dependend on input language" do
        Rstt.set_input lang: "en", content: ""
        Rstt.build_tagging_command.should == ("tree-tagger-english")
      end
    
      it "should prefer utf8 over other" do
        Rstt.set_input lang: "de", content: ""
        Rstt.build_tagging_command.should == ("tree-tagger-german-utf8")
      end
    end # language finding and command building
    
    describe "output format" do
      before(:each) do
        @input = {lang: "de", content: "Das ist ein einfacher Dummy Satz"}
      end
      it "should be an array as output" do
        Rstt.set_input @input
        Rstt.preprocessing
        Rstt.tagging.should be_a Array
      end
      it "should have correct count" do
        Rstt.set_input @input
        verfifier = @input[:content].split(" ").length
        Rstt.preprocessing
        Rstt.tagging
        Rstt.tagged.should have(verfifier).things
      end
      
      # testing output format, means: for each word in given input gives an array
      # with: 1. input word, 2. tagging category, 3. lemma
      # could be done over output length
      it "should have correct output format" do
        Rstt.set_input @input
        Rstt.preprocessing
        Rstt::LANGUAGES
        Rstt.tagging.first.should have(3).things
      end
    end # output format
    
  end # tagging stages
end
