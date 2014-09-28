$LOAD_PATH << '.'

require 'words'
require 'sentences'

if ARGV[0].nil?
	puts "Error: give me a text file.. I am hungry"
	exit
end

# 1. Get the words
words = Words.words(ARGV[0])
puts
Puts "Words are loaded"

# 2. Get the sentences
sentences = Sentence.sentences(ARGV[0])
puts
puts "Sentences are loaded"

# 3. For each word find 3 sentences
result = Hash.new { |hash, key| hash[key] = Hash.new({}) }
counter = 1

for word in words
	knownWords = Words.knownWords(words, word)
	sample_sentences = Sentence.sentenceForWord(word, knownWords, sentences, 10)
	result[word]['sample_sentences'] = sample_sentences

	if result.keys.length > 100
		Sentence.writeHashToJsonFile(result, "Package-#{counter}.json")
		counter = counter + 1
		result.clear
		puts "Package #{counter} created"
	end
end
