module ObjectStore
  
  def ObjectStore.add_object(object_counter,object_store,object_to_add)
    object_name = object_to_add[:object_name]
    duplicate_detected = false
    object_store.each do |object|
      if object[:object_name] == object_name
        duplicate_detected = true
        raise "Two objects cannot have an identical name."
      end
    end
    unless duplicate_detected == true
      object_store.push object_to_add
      object_counter =+ 1
      object_to_add[:object_id] = object_counter
      return { object_counter: object_counter, store_content: object_store}
    end
  end

  def ObjectStore.find(init_object_store,object_to_find)
    output_object = nil
    if object_to_find.is_a?(String)
      init_object_store.each do |object|
        if object[:object_name] == object_to_find
          output_object = object
        end
      end 
      return output_object
    elsif object_to_find.is_a?(Fixnum)
      init_object_store.each do |object|
        if object[:object_id] == object_to_find
          output_object = object
        end
      end 
      return output_object
    end
  end

end
