gem "minitest"
require "minitest/autorun"
require_relative "../lib/scanner"

class TestScanner < Minitest::Test

  def test_tokenize
    test_line = " 	SimpleTest foo  "
    assert_equal [1,"SimpleTest","foo"], Scanner.tokenize( test_line, 1 )
  end

  def test_id_token
    test_token = "SimpleTest"
    assert_equal [:slot_name, "SimpleTest"], Scanner.id_token( test_token )
    test_token = "(1 + 1)"
    assert_equal [:math_exp, "(1 + 1)"], Scanner.id_token( test_token )
    test_token = "\"String Literal\""
    assert_equal [:string_lit, "String Literal"], Scanner.id_token( test_token )
  end

  def test_tag_tokens
    tokenized_line = [1,"SimpleTest","foo"]
    assert_equal [1, [:slot_name, "SimpleTest"], [:slot_name, "foo"]], Scanner.tag_tokens( tokenized_line )
  end

end
