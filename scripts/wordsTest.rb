$LOAD_PATH << '.'

require 'words'
require "minitest/autorun"
require "sentences"

class TestWord < Minitest::Test

  def test_1
    words = Words.words('wordsTest.txt')
    assert_equal words.length > 0, true
  end

  def test_2
    knownWords = Words.knownWords(['ich', 'dish', 'mich'], 'dish')
    assert_equal knownWords, ['dish', 'mish']
  end


end

