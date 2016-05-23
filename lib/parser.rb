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

end
