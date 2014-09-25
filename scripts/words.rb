require 'json'

module Words
  def Words.words(filename)
    hash_of_words = Hash.new(0)
    file = File.open(filename, 'r')
    file.each_line do |line|
      words = Words.wordsFromString(line)
      words.each do |word|
          hash_of_words[word] = hash_of_words[word] + 1
      end
    end
    file.close
    hash_of_words.sort_by { |key, value| -value}
  end

  def Words.wordsFromString(input_string)
    result = []
    words = input_string.gsub("\n", '').split(' ')
    words.each do |word|
      word = word.gsub(/[;:,\.']/, '')
      if word
        word = word.downcase
        result << word
      end 
    end
    result
  end
end

#sortedValues = Words.words(ARGV[0])

#File.open('words.json', 'w') do |f|
#  f.write(sortedValues.to_json)
#  f.close
#end
