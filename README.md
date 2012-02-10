TreeTagger for Ruby
===================

DESCRIPTION
-------------------
The Ruby based wrapper for the TreeTagger by Helmut Schmid.
Check it out if you are interested
in Natural Language Processing (NLP) and Human Language Technology (HLT).

INSTALLATION + REQUIREMENTS
-------------------
Before you install the treetagger-ruby package please ensure you have downloaded and installe the [TreeTagger](http://www.ims.uni-stuttgart.de/projekte/corplex/TreeTagger/) itself.  
(And pls, respect his terms of license)

		gem install rtt
		thor config:init /path/to/your/TreeTagger/

or:

		rtt -i /path/to/your/TreeTagger/

USAGE
-------------------

You have some `class`, where you want to use Rtt ..  
the input is given by: `Rtt.set_input lang: lang, content: content` with default language '`en`';  
accessible languages could be found by `Rtt.language_codes`;  
installed languages are stored in `Rtt::LANGUAGES` (cause it could be different)


		class Foo
			include Rtt
			
			def pos_tagging(lang,content)
				Rtt.set_input lang: lang, content: content
				Rtt.preprocessing
				Rtt.tagging
				processed_ data = Rtt.tagged
			end
		end

that's all, the processed data are accessible via `Rtt.tagged`,  
it is an Array, thereby each element self is an Array with following elements

	1. the input word itself
	2. the word class
	(3. the lemma of the input; depends on your input language)


