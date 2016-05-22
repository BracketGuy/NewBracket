module Scanner

  def Scanner.tokenize(line_text)
    final_array = []
    line = line_text.split(' ')
    line.map! { |line| final_array.push line } 
    return final_array
  end

  def Scanner.shave_token(token, symbol)
    return_token = token.chomp(symbol)
    return_token.slice!(0)
    return return_token
  end

  def Scanner.id_token(token)
    final_array = []
    if token[0] == "(" && token[-1, 1] == ")"
      final_array.push :math_exp
      final_array.push Scanner.shave_token(token, ")")
    elsif token[0] == "\"" && token[-1, 1] == "\""
      final_array.push :string_lit
      final_array.push Scanner.shave_token(token, "\"")
    elsif token[0] == "[" && token[-1, 1] == "]"
      final_array.push :obj_name
      final_array.push Scanner.shave_token(token, "]")
    elsif token == "L"
      final_array.push :stack_symbol
    elsif token == ">"
      final_array.push :branch_symbol
    else
      final_array.push :slot_name
      if token.include? ?/
        tmp_array = token.split('/')
        tmp_array.each do |sub_token|
          final_array.push sub_token
        end
      else
        final_array.push token
      end
    end
    return final_array
  end

  def Scanner.tag_tokens(line)
    final_array = []
    line.each do |value|
      final_array.push Scanner.id_token(value)
    end
    return final_array
  end

  def Scanner.scan_line(line)
    tokenized_line = Scanner.tokenize(line)
    taged_line = Scanner.tag_tokens(tokenized_line)
  end
 
end
