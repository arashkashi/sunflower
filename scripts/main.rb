$LOAD_PATH << '.'

require 'words'
require 'sentences'

if ARGV[0].nil?
	puts "Error: give me a text file.. I am hungry"
	exit
end

# 1. Get the words
words, sentences = Words.words(ARGV[0])
puts
puts "Words are loaded: #{words.length}"
puts "Sentences are loaded: #{sentences.length}"

# 3. For each word find 3 sentences
result = Hash.new { |hash, key| hash[key] = Hash.new({}) }
counter = 1
progress_counter = 0
number_of_words = 10000

puts "Getting sentences for words (#{Time.new})... "

for word in words.take(number_of_words)
	startTime = Time.new
	progress_counter = progress_counter + 1
	knownWords = Words.knownWords(words, word)
	endTime = Time.new
	sample_sentences = Sentence.sentenceForWord(word, knownWords, sentences, 4)
	result[word]['sample_sentences'] = sample_sentences
	result[word]['meanings'] = []
	print "\t#{'%.02f %' % (progress_counter.to_f * 100.0/ number_of_words.to_f)} \t of words \t\tDURATION:#{endTime - startTime})\r"


	if result.keys.length > 100
		Sentence.writeHashToJsonFile(result, "Package-#{counter}.json")
		puts "Package #{counter} created"
		counter = counter + 1
		result.clear
	end
end
