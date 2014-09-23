require 'json'

hash_of_words = Hash.new(0)

file = File.open(ARGV[0], 'r')

file.each_line do |line|
    words = line.split(' ')
    words.each do |word|
      word = word.gsub(/[;:,\.']/, '')
      if word
        word = word.downcase
        hash_of_words[word] = hash_of_words[word] + 1
      end
    end
end
sorted_values = hash_of_words.sort_by { |key, value| -value}

File.open('words.json', 'w') do |f|
  f.write(sorted_values.to_json)
end

