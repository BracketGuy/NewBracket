require_relative "lib/scanner"

line_number = 0
program_source = []
code = File.open('test.br').read
code.each_line do |line|
  line_number += 1
  unless line.strip.empty?
    program_source.push Scanner.scan_line( line, line_number )
  end
end
puts program_source.inspect
