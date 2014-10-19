$LOAD_PATH << '.'

require 'translate'
require 'sentences'

if ARGV[0].nil?
	puts "Error: give me a json file.."
	exit
end

puts Sentence.loadJsonFileAsHash(ARGV[0])



