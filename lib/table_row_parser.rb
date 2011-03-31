require File.expand_path('../internal_table_row_parser', __FILE__)

class TableRowParser
  def initialize
    @parser = InternalTableRowParser.new
  end

  def parse(string)
    simplify(stringify(@parser.parse(string)))
  end

  # internal methods

  def stringify(array)
    array.map do |item|
      h = {}
      item.each { |k, v| h[k] = v.to_s }
      h
    end
  end

  def simplify(array)
    output = []
    previous = {}
    array.each do |current|
      if (previous.keys & current.keys).empty?
        output << current
      else
        output[-1].merge!(current) { |k, a, b| "#{a}; #{b}" }
      end
      previous = current
    end
    output
  end
end
