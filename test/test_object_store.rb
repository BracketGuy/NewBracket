require 'rubygems'
gem "minitest"
gem 'mocha'
require "minitest/autorun"
require 'mocha/mini_test'
require_relative "../lib/object_store"

class TestObjectStore < Minitest::Test

  def test_add_object
    object_to_add = { object_name: "main", object_content: [{ slot_name: "string", slot_type: "string", slot_value: "foo" }] }
    object_store_target = [{ object_name: "main", object_content: [{ slot_name: "string", slot_type: "string", slot_value: "foo"}], object_id: 1 }]
    init_object_store = []
    object_store_with_added_object = ObjectStore.add_object(0,init_object_store,object_to_add)[:store_content]
    assert_equal object_store_target, object_store_with_added_object
    #object should have been assigned an object_id
    assert_equal 1, object_store_with_added_object[0][:object_id]
    #We shouldn't be able to add an object with the same name:
    assert_raises RuntimeError do 
      ObjectStore.add_object(1,init_object_store,object_to_add)
    end
  end

  def test_find_object 
    test_object_store = [{ object_name: "first",  object_content: [{ slot_name: "string", slot_type: "string", slot_value: "foo" }], object_id: 1 },
                         { object_name: "second", object_content: [{ slot_name: "string", slot_type: "string", slot_value: "bar" }], object_id: 2 }]
    object_we_want = { object_name: "second", object_content: [{ slot_name: "string", slot_type: "string", slot_value: "bar" }], object_id: 2 }
    #search by name
    assert_equal object_we_want, ObjectStore.find(test_object_store,"second")
    #search by object_id
    assert_equal object_we_want, ObjectStore.find(test_object_store,2)
  end

end
