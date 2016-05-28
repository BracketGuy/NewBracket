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

    #So.... Do we need to have group_slots or stuff_slots detect stacked slots? because if we don't, I don't see how parse_slot is going to handle
    #that because it has to return a single slot, and a stacked slot is really many slots.

    #unparsed = [[:stack_symbol], [:slot_name, "ObjectName1"], [:slot_name, "ObjectName2"], [:slot_name, "ObjectName3"], [:term_symbol]]
    #parsed = {  }
    #assert_equal parsed, Parser.parse_slot( unparsed )
  end

  def test_stuff_slots
    stuffed = [["main", { slot_name: "string", slot_type: "string", slot_value: "foo" }]]
    unstuffed = [["main", [:slot_name, "string"], [:string_lit, "foo"], [:term_symbol]]]
    #assert_equal stuffed, Parser.stuff_slots( unstuffed )
  end

  def test_seperate_variables
    unseperated = "2 + 4 + foo - 45 * 4.5 + Bar"
    seperated = ["2 + 4 + ", "foo", " - 45 * 4.5 + ", "Bar"]
    assert_equal seperated, Parser.seperate_variables( unseperated )
    unseperated = "Foo 2 * 4 + bar - 45 * 4.5"
    seperated = ["Foo", " 2 * 4 + ", "bar", " - 45 * 4.5"]
    assert_equal seperated, Parser.seperate_variables( unseperated )
    unseperated = "        Foo 2 * 4 +    bar - 45 * 4.5     "
    seperated = ["Foo", " 2 * 4 +    ", "bar", " - 45 * 4.5"]
    assert_equal seperated, Parser.seperate_variables( unseperated )
  end

end
