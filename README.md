TreeTagger for Ruby
===================

DESCRIPTION
-----------

The Ruby based wrapper for the TreeTagger by Helmut Schmid.
Check it out if you are interested
in Natural Language Processing (NLP) and Human Language Technology (HLT).

INSTALLATION + REQUIREMENTS
---------------------------

Before you install the treetagger-ruby package please ensure you have downloaded and installe the [TreeTagger](http://www.ims.uni-stuttgart.de/projekte/corplex/TreeTagger/) itself.  
(And pls, respect his terms of license)

		gem install rstt
		thor config:init /path/to/your/TreeTagger/

or:

		rstt -i /path/to/your/TreeTagger/

USAGE
-----

1. You have some `class`, where you want to use Rstt ..  
the input is given by: `Rstt.set_input lang: lang, content: content` with default language '`en`';  
accessible languages could be found by `Rstt.language_codes`;  
installed languages are stored in `Rstt::LANGUAGES` (cause it could be different)

		class Foo
			include Rstt
			
			def pos_tagging(lang,content)
				Rstt.set_input lang: lang, content: content
				Rstt.preprocessing
				Rstt.tagging
				processed_ data = Rstt.tagged
			end
		end

	that's all, the processed data are accessible via `Rstt.tagged`,  
	it is an Array, thereby each element self is an Array with following elements

	1. the input word itself
	2. the word class
	3. the lemma of the input; depends on your input language

2. or via CLI, check usage with `rstt -h`

LICENSE
-------

see License.txt
