module Parser

  def Parser.group_slots( source )
    object_id = 0
    output_array = []
    source.each_with_index do |line,index|
      if line[0] == :obj_name
        object_id += 1
        output_array.push []
        output_array[object_id - 1].push line[1]
      else
        output_array[object_id - 1].push line
      end
    end
    return output_array
  end

  def Parser.parse_slot( source )
    output_hash = {}

    if source.length == 2                        # Only two things in a slot should be us asking another object to be evaluated. (obj name and term)
      output_hash[:slot_name] = source[0][1]
      output_hash[:slot_type] = "object_reference"
      output_hash[:slot_value] = nil
    elsif source.length == 3                     # Three things in a slot is a slot name, a slot value, 
      source.each_with_index do |token,index|
        if token[0] == :slot_name && index == 0
          output_hash[:slot_name] = token[1]
        elsif token[0] == :string_lit
          output_hash[:slot_type] = "string"
          output_hash[:slot_value] = token[1]
        end
      end
    else                                         # Is more than three tokens in a slot a valid case?
      #                                          
    end

    return output_hash
  end

  def Parser.stuff_slots( source )
    output_array = []
    source.each do |object|
      this_object = []
      object.each_with_index do |token,index|
        if index == 0
          this_object.push token
        else
          
          # MAGIC!!!!!

          # Magic call to parse_slot for each chunk of slot tokens goes here.
          
          # MAGIC!!!!!

        end
      end
      output_array.push this_object
      this_object = []
    end
    return output_array
  end

end
