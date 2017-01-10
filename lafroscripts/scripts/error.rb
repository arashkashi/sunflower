$LOAD_PATH << '.'

module Error

  def Error.error(msg)
    puts "ERROR::#{msg}"
    gets
  end

end


