$LOAD_PATH << '.'

require 'words'
require 'sentences'

# 1. Get the words
words = Words.words(ARGV[0])
print "Words are loaded"

# 2. Get the sentences
sentences = Sentence.sentences(ARGV[0])
print "Sentences are loaded"

# 3. For each word find 3 sentences
for word in words
  knownWords = Words.knownWords(words, word)
  example_sentences = Sentence.sentenceForWord(word, knownWords, sentences, 3)
  puts "*" * 40
  puts word
  puts example_sentences
  puts "-" * 40
end
