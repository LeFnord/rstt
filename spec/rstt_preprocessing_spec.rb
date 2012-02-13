# coding: utf-8
require "spec_helper"

describe Rstt do
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
      
      @real_2    = "<h3>ToDos: Think</h3><div><ul><li>Title editierbar machen&nbsp;✗</li><ul><li>mmh, ist wohl besser, wenn es so bleibt, beim ersten anlegen wird ein Titel gebastelt und gut ist, so bleibt auch der slug konsistent</li></ul><li>deployen auf Arielle, evtl. über einen BitBucket Account (als Repository)&nbsp;✓</li><li>Abbildungen und andere Objekte als Attachement ermöglichen</li><li>Tabellen erstellen (evtl. Berechnungen?)</li><ul><li>dafür wird wohl ein anderer Editor nötig sein, folgende kämen dafür in Frage:</li><ul><li><a href='http://jejacks0n.github.com/mercury/' title='MercuryEdit' target='_blank'>MercuryEdit</a><br></li><li><a href='http://www.aloha-editor.org/' title='AlohaEditor' target='_blank'>AlohaEditor</a><br></li><li><a href='http://ckeditor.com/' title='CKEditor' target='_blank'>CKEditor</a><br></li></ul><li>wahrscheinlich kommt der&nbsp;<a href='http://www.aloha-editor.org/' title='AlohaEditor' target='_blank' style='margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 2px; padding-right: 3px; padding-bottom: 2px; padding-left: 3px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; font-size: 13px; font: inherit; vertical-align: baseline; border-style: initial; border-color: initial; border-style: initial; border-color: initial; border-style: initial; border-color: initial; border-style: initial; border-color: initial; border-style: initial; border-color: initial; color: rgb(153, 153, 153); text-decoration: none; '>AlohaEditor</a>&nbsp;in Frage ( insbesondere:&nbsp;<a href='http://www.aloha-editor.org/demos/aloha-world-example/' title='AlohaEditor|World' target='_blank'>AlohaEditor|World</a>)</li></ul><li>Referenzierung unter den Notes ermöglichen</li></ul></div>"
    end
    
    it "should replace a string by itself" do
      Rstt.set_input lang: "en", content: @string
      Rstt.preprocessing
      Rstt.content.should == @control_1
    end

    it "should replace non alphanum caharacters within words with nothings" do
      Rstt.set_input lang: "en", content: @extra
      Rstt.preprocessing
      Rstt.content.should == @control_2
    end
    
    it "should delete non letter characters" do
      Rstt.set_input lang: "de", content: @real
      Rstt.preprocessing
      Rstt.content.should == @control_r
    end
    
    it "should clean up input from html and non word characters" do
      Rstt.set_input lang: "de", content: @real_2
      Rstt.preprocessing
    end
    
    describe "preprocessing:html" do
      before(:each) do
        path = File.join(File.dirname(__FILE__), '..', 'tmp','tmp.html')
        @html_file = File.open(path)
      end

      it "should load the given html file" do
        file = @html_file.read
        Rstt.set_input lang: "en", content: file
        Rstt.preprocessing
        Rstt.content.should_not match(/<\/?[^>]*>/)
      end
    end
    
  end
end
