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

end
