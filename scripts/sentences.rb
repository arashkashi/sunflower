require 'json'

hash_of_sentences = Hash.new(0)

file = File.open(ARGV[0], 'rb')

file.each_line do |raw_sentence|
  words = raw_sentence.split(' ')
  key = []
  words.each do |word|
    if word
      word = word.downcase
      key << word
    end
  end
  if key.length > 0
    key = key.sort
    hash_of_sentences[key] = raw_sentence
  end

  break if hash_of_sentences.length > 10
end

print hash_of_sentences

File.open('sentences.json', 'w') do |f|
  f.write(hash_of_sentences.to_json)
end
