file = File.open(ARGV[0], 'r')

file.each_line do |line|
    print line
end
