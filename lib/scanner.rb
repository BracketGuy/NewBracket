module Scanner

  def Scanner.tokenize(input_string)
    output_array = []
    output_string = ""
    in_whitespace = false
    in_math_exp = false
    in_string_lit = false
    input_string.each_char do |char|
      if char == "(" && in_math_exp == false
        in_math_exp = true
        unless output_string == ""
          output_array.push output_string
          output_string = ""
        end
        output_string << char
      elsif char == ")" && in_math_exp == true
        in_math_exp = false
        output_string << char
        unless output_string == ""
          output_array.push output_string
          output_string = ""
        end
      elsif char == "\"" && in_math_exp == true
        raise "A double quote can never occur within a math expression!"
      elsif in_math_exp == true
        output_string << char
      elsif char == "\"" && in_string_lit == false
        in_string_lit = true
        unless output_string == ""
          output_array.push output_string
          output_string = ""
        end
        output_string << char
      elsif char == "\"" && in_string_lit == true
        in_string_lit = false
        output_string << char
        unless output_string == ""
          output_array.push output_string
          output_string = ""
        end
      elsif in_string_lit == true
        output_string << char
      elsif char =~ /\s/ && in_whitespace == false
        in_whitespace = true
        unless output_string == ""
          output_array.push output_string
          output_string = ""
        end
      elsif char !~ /\s/ && in_whitespace == true
        in_whitespace = false
        output_string << char
      elsif char !~ /\s/ && in_whitespace == false
        output_string << char
      end
    end
    unless output_string == ""
      output_array.push output_string
      output_string = ""
    end
    return output_array
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
    elsif token == "."
      final_array.push :term_symbol
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
    tagged_line = Scanner.tag_tokens(tokenized_line)
    unless tagged_line.last == [:term_symbol]
      tagged_line.push [:term_symbol]
    end
    return tagged_line
  end
 
end
