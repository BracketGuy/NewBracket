require_relative "lib/scanner"
require_relative "lib/parser"

program_source = []
code = File.open('test.br').read
code.each_line do |line|
  unless line.strip.empty?
    program_source.push Scanner.scan_line( line )
  end
end
