# coding: utf-8
require "spec_helper"

describe Rtt do
  describe "Preprocessing" do
    before(:each) do
      @control_1 = "Am 13.04.1899 ist es geschehen - was steht woanders. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nam cursus. Morbi ut mi. Nullam enim leo, egestas id, condimentum at, laoreet mattis, massa."
      @string    = "Am 13.04.1899 ist es geschehen – was steht woanders. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nam cursus. Morbi ut mi. Nullam enim leo, egestas id, condimentum at, laoreet mattis, massa."
      @control_2 = "Am 13.04.1899 ist es geschehen - was steht woanders. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nam cursus. Morbi ut mi. Null-am e-nim leo, egestas id, condimentum at, laoreet mattis, massa."
      @extra     = "Am 13.04.1899 ist es geschehen – was steht woanders. Lo#rem ipsum d#olor sit am%et, cons^ect$etuer adipiscing e@lit. Nam cursus. Morbi ut mi. Null-am e--nim leo, egestas id, condimentum at, laoreet mattis, massa."
      @control_3 = "Am 13.04.1899 ist es geschehen - was steht woanders. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nam cursus. Morbi ut mi. Null-am e-nim leo, egestas id, condimentum at, laoreet mattis, massa."
      @getaggt   = "Am 13.04.1899 ist es geschehen – was steht woanders. Lo#rem ipsum d#olor sit am%et, cons^ect$etuer adipiscing e@lit. Nam cursus. Morbi ut mi. Null-am e--nim leo, egestas id, condimentum at, laoreet mattis, massa."
      
      @real      = "Title editierbar machen ✗ mmh, ist wohl besser, wenn es so bleibt, beim ersten anlegen wird ein Titel gebastelt und gut ist, so bleibt auch der slug konsistent deployen auf Arielle, evtl. über einen BitBucket Account (als Repository) ✓"
      @control_r = "Title editierbar machen mmh, ist wohl besser, wenn es so bleibt, beim ersten anlegen wird ein Titel gebastelt und gut ist, so bleibt auch der slug konsistent deployen auf Arielle, evtl. über einen BitBucket Account als Repository"
    end
    
    it "should replace a string by itself" do
      Rtt.set_input lang: "en", content: @string
      Rtt.preprocessing
      Rtt.content.should == @control_1
    end

    it "should replace non alphanum caharacters within words with nothings" do
      Rtt.set_input lang: "en", content: @extra
      Rtt.preprocessing
      Rtt.content.should == @control_2
    end
    
    it "should delete non letter characters" do
      Rtt.set_input lang: "de", content: @real
      Rtt.preprocessing
      Rtt.content.should == @control_r
    end
    
    describe "preprocessing:html" do
      before(:each) do
        path = File.join(File.dirname(__FILE__), '..', 'tmp','tmp.html')
        @html_file = File.open(path)
      end

      it "should load the given html file" do
        file = @html_file.read
        Rtt.set_input lang: "en", content: file
        Rtt.preprocessing
        Rtt.content.should_not match(/<\/?[^>]*>/)
      end
    end
    
  end
end
