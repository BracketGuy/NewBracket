gem "minitest"
require "minitest/autorun"
require_relative "../lib/scanner"

class TestScanner < Minitest::Test

  def test_tokenize
    test_line = " 	SimpleTest foo  "
    assert_equal ["SimpleTest","foo"], Scanner.tokenize( test_line )

    # Need a function called from tokenize that removes whitespace from inside
    # math expressions. Although, how does that work for quotes?

    #test_line = " 	SimpleTest ( 4 + 5 )"
    #assert_equal ["SimpleTest","( 4 + 5 )"], Scanner.tokenize( test_line )
  end

  def test_shave_token
    test_token = "(with parens)"
    assert_equal "with parens", Scanner.shave_token( test_token, ")" )
    test_token = "\"with quotes\""
    assert_equal "with quotes", Scanner.shave_token( test_token, "\"" )
    test_token = "[with brackets]"
    assert_equal "with brackets", Scanner.shave_token( test_token, "]" )
  end

  def test_id_token
    test_token = "SimpleTest"
    assert_equal [:slot_name, "SimpleTest"], Scanner.id_token( test_token )
    test_token = "ObjectName/SlotName/SlotValue"
    assert_equal [:slot_name, "ObjectName", "SlotName", "SlotValue"], Scanner.id_token( test_token )
    test_token = "(1 + 1)"
    assert_equal [:math_exp, "1 + 1"], Scanner.id_token( test_token )
    test_token = "\"String Literal\""
    assert_equal [:string_lit, "String Literal"], Scanner.id_token( test_token )
    test_token = "[ObjectName]"
    assert_equal [:obj_name, "ObjectName"], Scanner.id_token( test_token )
    test_token = "L"
    assert_equal [:stack_symbol], Scanner.id_token( test_token )
    test_token = ">"
    assert_equal [:branch_symbol], Scanner.id_token( test_token )
    test_token = "."
    assert_equal [:term_symbol], Scanner.id_token( test_token )
  end

  def test_tag_tokens
    tokenized_line = ["SimpleTest","foo"]
    assert_equal [[:slot_name, "SimpleTest"], [:slot_name, "foo"]], Scanner.tag_tokens( tokenized_line )
    tokenized_line = ["[main]","SomeSlotName","(3)"]
    assert_equal [[:obj_name, "main"], [:slot_name, "SomeSlotName"], [:math_exp, "3"]], Scanner.tag_tokens( tokenized_line )
  end

  def test_scan_line
    line = "L > SlotName SlotNameorValue SlotNameorValue ."
    test_array = [[:stack_symbol], [:branch_symbol], [:slot_name, "SlotName"], [:slot_name, "SlotNameorValue"], 
                  [:slot_name, "SlotNameorValue"], [:term_symbol]]
    assert_equal test_array, Scanner.scan_line( line )
    line = "    [main]     \n   string \"foo\""
    test_array = [[:obj_name, "main"], [:slot_name, "string"], [:string_lit, "foo"], [:term_symbol]]
    assert_equal test_array, Scanner.scan_line( line )
  end

end
