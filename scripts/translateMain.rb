$LOAD_PATH << '.'

require 'translate'
require 'sentences'

if ARGV[0].nil?
	puts "Error: give me a json file.."
	exit
end
# Initate the final result
result = Hash.new()
counter = 0

# Load the raw learning Pack
filename = ARGV[0]
learningPackHash = Sentence.loadJsonFileAsHash(filename)

# Translate the learning pack
learningPackHash.each do |key, hash|
	list_to_be_translated = []
	list_to_be_translated << key << hash[:sample_sentences.to_s]
	list_to_be_translated = list_to_be_translated.flatten

	translations_hash = Translate.do(list_to_be_translated)
	translaion_list = Translate.parseHashToList(translations_hash)
	
	result[key] = Hash.new()
	result[key]["meaning"] = translaion_list[0]
	result[key][:sample_sentences.to_s] = hash[:sample_sentences.to_s]
	result[key][:translated_sample_sentence.to_s] = translaion_list[1..-1]

	print "\t#{counter} \t words are translated ... \r"
	counter = counter + 1
end

Sentence.writeHashToJsonFile(result, "#{filename}_translated.json")



