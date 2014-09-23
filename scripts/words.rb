require 'json'

hash_of_words = Hash.new(0)

file = File.open(ARGV[0], 'r')

file.each_line do |line|
    words = line.split(' ')
    words.each do |word|
        hash_of_words[word] = hash_of_words[word] + 1
    end
end

print hash_of_words
