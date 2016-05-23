gem "minitest"
require "minitest/autorun"
require_relative "../lib/parser"

class TestParser < Minitest::Test

  def test_group_slots
    grouped = [["main", [:slot_name, "string"], [:string_lit, "foo"]]]
    ungrouped = [[:obj_name, "main"], [:slot_name, "string"], [:string_lit, "foo"]]
    assert_equal grouped, Parser.group_slots( ungrouped )
    grouped = [["Obj1", [:slot_name, "string"], [:string_lit, "foo"]], ["Obj2", [:slot_name, "string"], [:string_lit, "bar"]]]
    ungrouped = [[:obj_name, "Obj1"], [:slot_name, "string"], [:string_lit, "foo"], 
                 [:obj_name, "Obj2"], [:slot_name, "string"], [:string_lit, "bar"]]
    assert_equal grouped, Parser.group_slots( ungrouped )
  end

end
