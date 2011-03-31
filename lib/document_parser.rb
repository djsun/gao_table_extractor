require File.expand_path('../table_parser', __FILE__)
require File.expand_path('../table_row_parser', __FILE__)
require 'pp'

# A GAO document is broken down into N sections, 0 to N-1. Here is how they
# are organized:
#
#   * Section 0: boilerplate for title, legal language
#   * Section 1: table of contents, list of tables, abbreviations
#   * Section 2: the main section
#   * Section 3+: appendices
#   * Section N-2: footnotes
#   * Section N-1: boilerplate on GAO mission, how to obtain copies, contacts

class DocumentParser
  def initialize
    @table_parser = TableParser.new
    @table_row_parser = TableRowParser.new
  end

  def parse(document)
    processed = preprocess(document)
    main      = get_main_section(processed)
    tables    = extract_tables(main)
    tables.map do |table_text|
      rows        = extract_table_rows(table_text)
      parsed_rows = parse_table_rows(rows)
      make_table_data(parsed_rows)
    end
  end

  def preprocess(input)
    string = input + "\n\n"
    string.gsub(/\[Empty\];\s?\n?/, "[Empty]; \n")
  end

  # Returns the main section when given a document.
  def get_main_section(string)
    string.split("[End of section] \n")[2]
  end

  # Returns the table sections when given a main section of a document.
  def extract_tables(main)
    sections = main.split("[End of table] \n")
    tables = []
    sections.each do |section|
      flag = false
      table = ""
      section.lines do |line|
        flag = true if line =~ /^Table /
        table << line if flag
      end
      tables << table unless table.empty?
    end
    tables
  end

  # Converts an array of table text into an array of arrays.
  # Only columns and values are kept.
  # Extra content, including source attributes and notes, are discarded.
  def extract_table_rows(table_text)
    rows = []
    parsed = @table_parser.parse(table_text)
    parsed[:table].each do |row|
      text = row[:row].to_s
      case text
      when /^Source: / then break
      when /^Note: / then break
      end
      rows << text
    end
    rows
  end

  def parse_table_rows(rows)
    rows.map do |row|
      parsed_row = @table_row_parser.parse(row + "\n")
      parsed_row.each_slice(2).map do |slice|
        key, val = slice[0][:key], slice[1][:val]
        raise "Unexpected" unless key && val
        key, val = clean(key.to_s), clean(val.to_s)
        val = nil if val == "[Empty]"
        [key, val]
      end
    end
  end

  def make_table_data(parsed_rows)
    columns = parsed_rows.map { |row| row.map { |pair| pair[0] } }.uniq
    raise "Inconsistent column names" unless columns.length == 1
    values  = parsed_rows.map { |row| row.map { |pair| pair[1] } }
    {
      :columns => columns.first,
      :values  => values
    }
  end

  def clean(string)
    string.gsub(/\n/, ' ').gsub(/\s\s/, ' ')
  end

end
