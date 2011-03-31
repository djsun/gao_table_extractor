require 'rubygems'
require 'bundler/setup'
require 'parslet'

class TableParser < Parslet::Parser
  rule(:table) {
    table_header >> table_row.repeat.as(:table)
  }
  rule(:table_header) {
    str("Table ") >> integer.as(:number) >> str(": ") >>
    string.as(:title) >> str("\n\n")
  }
  rule(:table_row) {
    (
      (str(". \n\n").absent? >> any).repeat >> str(". ")
    ).as(:row) >> str("\n\n")
  }
  rule(:string) {
    (str("\n\n").absent? >> any).repeat
  }
  rule(:integer) {
    match['0-9'].repeat(1)
  }
  root(:table)
end
