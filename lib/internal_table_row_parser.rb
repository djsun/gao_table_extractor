require 'rubygems'
require 'bundler/setup'
require 'parslet'

class InternalTableRowParser < Parslet::Parser
  rule(:row) {
    group.repeat
  }
  rule(:group) {
    (last_pair.absent? >> pair).repeat >> last_pair
  }
  rule(:pair) {
    key >> value
  }
  rule(:last_pair) {
    key >> last_value
  }
  rule(:key) {
    (str(": ").absent? >> any).repeat.as(:key) >> str(": ")
  }
  rule(:value) {
    s_value.repeat(1)
  }
  rule(:last_value) {
    s_value.repeat >> p_value.repeat(1)
  }
  rule(:s_value) {
    (str(": ").absent? >> str("; \n").absent? >> any).repeat.as(:val) >> str("; \n")
  }
  rule(:p_value) {
    (str(": ").absent? >> str(". \n").absent? >> any).repeat.as(:val) >> str(". \n")
  }
  root(:row)
end
