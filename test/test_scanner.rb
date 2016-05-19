gem "minitest"
require "minitest/autorun"
require_relative "../lib/scanner"

class TestScanner < Minitest::Test

  def test_tokenize
    test_line = " 	SimpleTest foo  "
    assert_equal [1,"SimpleTest","foo"], Scanner.tokenize( test_line, 1 )
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
  end

  def test_tag_tokens
    tokenized_line = [1,"SimpleTest","foo"]
    assert_equal [1, [:slot_name, "SimpleTest"], [:slot_name, "foo"]], Scanner.tag_tokens( tokenized_line )
    tokenized_line = [2,"[main]","SomeSlotName","(3)"]
    assert_equal [2, [:obj_name, "main"], [:slot_name, "SomeSlotName"], [:math_exp, "3"]], Scanner.tag_tokens( tokenized_line )
  end

  def test_scan_line
    line =  "L > SlotName SlotNameorValue SlotNameorValue "
    test_array = [3, [:stack_symbol], [:branch_symbol], [:slot_name, "SlotName"], [:slot_name, "SlotNameorValue"], [:slot_name, "SlotNameorValue"]]
    assert_equal test_array, Scanner.scan_line( line, 3 )
  end

end
