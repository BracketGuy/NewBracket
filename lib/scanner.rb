module Scanner

  def Scanner.tokenize(line_text,line_number)
    final_array = []
    final_array.push line_number
    line = line_text.split(' ')
    line.map! { |line| final_array.push line } 
    return final_array
  end

  def Scanner.id_token(token)
    final_array = []
    if token[0] == "("
      final_array.push :math_exp
      final_array.push token
    elsif token[0] == "\""
      final_array.push :string_lit
      chomped_token = token.chomp('"')
      chomped_token.slice!(0)
      final_array.push chomped_token
    else
      final_array.push :slot_name
      final_array.push token
    end
    return final_array
  end

  def Scanner.tag_tokens(line)
    final_array = []
    line.each_with_index do |value,index|
      if index == 0
        final_array.push value
      else
        final_array.push Scanner.id_token(value)
      end
    end
    return final_array
  end

end
