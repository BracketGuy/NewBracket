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
    assert_equal stuffed, Parser.stuff_slots( unstuffed )
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

  def test_show_vals_needed_for_math
    #Takes an already-seperated math expression.
    math_exp = ["2 + 4 + ", "foo", " - 45 * 4.5 + ", "Bar"]
    #And tells us which values we are going to need to lookup in the object system.
    needed_vals = ["foo","Bar"]
    assert_equal needed_vals, Parser.show_vals_needed_for_math( math_exp )
  end

  def test_replace_math_vals
    math_exp = ["2 + 4 + ", "foo", " - 45 * 4.5 + ", "Bar"]
    needed_vals = ["foo","Bar"]
    vals = ["3","5"]
    # replace_math_vals takes a math expression and two arrays of identical length. The first is
    # a list of value names and the second is the values for each of those.
    assert_equal ["2 + 4 + ", "3", " - 45 * 4.5 + ", "5"], Parser.replace_math_vals( math_exp, needed_vals, vals )
  end

  def test_math_integration_test
    unseperated = "2 + foo + 3 + Bar"
    math_exp = Parser.seperate_variables( unseperated )
    needed_vals = Parser.show_vals_needed_for_math( math_exp )
    #This is a placeholder for when we have real lookups in the object system:
    vals = ["3","2"]
    to_eval = Parser.replace_math_vals( math_exp, needed_vals, vals )
    #this is basicly how the interpreter will work:
    assert_equal 10, eval(to_eval.join)
  end

end
