gem "minitest"
require "minitest/autorun"
require_relative "../lib/parser"

class TestParser < Minitest::Test

  def test_group_slots
    grouped = [["main", [:slot_name, "string"], [:string_lit, "foo"], [:term_symbol]]]
    ungrouped = [[:obj_name, "main"], [:slot_name, "string"], [:string_lit, "foo"], [:term_symbol]]
    assert_equal grouped, Parser.group_slots( ungrouped )
    grouped = [["Obj1", [:slot_name, "string"], [:string_lit, "foo"], [:term_symbol]], 
               ["Obj2", [:slot_name, "string"], [:string_lit, "bar"], [:term_symbol]]]
    ungrouped = [[:obj_name, "Obj1"], [:slot_name, "string"], [:string_lit, "foo"], [:term_symbol],
                 [:obj_name, "Obj2"], [:slot_name, "string"], [:string_lit, "bar"], [:term_symbol]]
    assert_equal grouped, Parser.group_slots( ungrouped )
  end

  def test_parse_slot 
    unparsed = [[:slot_name, "ObjectName"], [:term_symbol]]
    parsed = { slot_name: "ObjectName", slot_type: "object_reference", slot_value: nil }
    assert_equal parsed, Parser.parse_slot( unparsed )
    unparsed = [[:slot_name, "string"], [:string_lit, "foo"], [:term_symbol]]
    parsed = { slot_name: "string", slot_type: "string", slot_value: "foo" }
    assert_equal parsed, Parser.parse_slot( unparsed )
  end

  def test_stuff_slots
    stuffed = [["main", { slot_name: "string", slot_type: "string", slot_value: "foo" }]]
    unstuffed = [["main", [:slot_name, "string"], [:string_lit, "foo"], [:term_symbol]]]
    #assert_equal stuffed, Parser.stuff_slots( unstuffed )
  end

end
