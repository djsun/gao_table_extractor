require 'rspec'
require File.expand_path('../../lib/table_row_parser', __FILE__)

describe TableRowParser do
  before do
    @parser = TableRowParser.new
  end

  it "Example 1" do
    @parser.parse("K1: V1A; \nV1B. \n").should == [
      { :key => "K1"}, { :val => "V1A; V1B" }
    ]
  end

  it "Example 2" do
    @parser.parse("K1: V1; \nK2: V2. \n").should == [
      { :key => "K1" }, { :val => "V1" },
      { :key => "K2" }, { :val => "V2" }
    ]
  end

  it "Example 3" do
    @parser.parse("K1: V1; \nK2: V2; \nK3: V3. \n").should == [
      { :key => "K1"}, { :val => "V1" },
      { :key => "K2"}, { :val => "V2" },
      { :key => "K3"}, { :val => "V3" }
    ]
  end

  it "Example 4" do
    @parser.parse("K1: V1A; \nV2B; \nK2: V2; \nK3: V3. \n").should == [
      { :key => "K1"}, { :val => "V1A; V2B" },
      { :key => "K2"}, { :val => "V2" },
      { :key => "K3"}, { :val => "V3" }
    ]
  end

  it "Example 5" do
    @parser.parse("K1: V1; \nK2: V2A; \nV2B; \nK3: V3. \n").should == [
      { :key => "K1"}, { :val => "V1" },
      { :key => "K2"}, { :val => "V2A; V2B" },
      { :key => "K3"}, { :val => "V3" }
    ]
  end

  it "Example 6" do
    @parser.parse("K1: V1; \nK2: V2; \nK3: V3A; \nV3B. \n").should == [
      { :key => "K1"}, { :val => "V1" },
      { :key => "K2"}, { :val => "V2" },
      { :key => "K3"}, { :val => "V3A; V3B" }
    ]
  end
end
