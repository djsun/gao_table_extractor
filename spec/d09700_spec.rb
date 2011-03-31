require 'rubygems'
require 'bundler/setup'
require 'rspec'
require File.expand_path('../../lib/document_parser', __FILE__)

describe DocumentParser do
  before do
    @parser = DocumentParser.new
    @document = File.read(File.expand_path('../../data/d09700.txt', __FILE__))
  end
  
  it "preprocess should be correct" do
    s = @parser.preprocess("branded gasoline types: [Empty]; Locations")
    s.should == "branded gasoline types: [Empty]; \nLocations\n\n"
  end

  it "extract_tables should be correct" do
    processed = @parser.preprocess(@document)
    main      = @parser.get_main_section(processed)
    tables    = @parser.extract_tables(main)
    tables.length.should == 2
    tables[0].should == TABLE_1_TEXT
    tables[1].should == TABLE_2_TEXT
  end

  it "extract_table_rows should be correct" do
    processed = @parser.preprocess(@document)
    main      = @parser.get_main_section(processed)
    tables    = @parser.extract_tables(main)
    rows = tables.map do |table_text|
      @parser.extract_table_rows(table_text)
    end
    rows.length.should == 2
    rows[0].should == TABLE_1_ROWS
    rows[1].should == TABLE_2_ROWS
  end

  it "extract_tables should be correct" do
    processed = @parser.preprocess(@document)
    main      = @parser.get_main_section(processed)
    tables    = @parser.extract_tables(main)
    parsed_rows = tables.map do |table_text|
      rows = @parser.extract_table_rows(table_text)
      parsed_rows = @parser.parse_table_rows(rows)
    end
    parsed_rows.length.should == 2
    parsed_rows[0].should == TABLE_1_PARSED_ROWS
    parsed_rows[1].should == TABLE_2_PARSED_ROWS
  end

  it "make_table_data should be correct" do
    processed = @parser.preprocess(@document)
    main      = @parser.get_main_section(processed)
    tables    = @parser.extract_tables(main)
    data = tables.map do |table_text|
      rows = @parser.extract_table_rows(table_text)
      parsed_rows = @parser.parse_table_rows(rows)
      @parser.make_table_data(parsed_rows)
    end
    data.length.should == 2
    data[0].should == TABLE_1_DATA
    data[1].should == TABLE_2_DATA
  end

end

TABLE_1_TEXT = <<TABLE_END
Table 1: Special Fuel Blends that Experienced Price Increases Greater 
than Conventional Gasoline Due to Unplanned Refinery Outages[A]: 

Gasoline type: Conventional[B] base case; 
Cents-per-gallon increases for unbranded gasoline types: 0.5; 
Cents-per-gallon increases for branded gasoline types: 0.2; 
Locations that require this gasoline type: Numerous cities, counties, 
and states; 
Time period sold: Throughout the time period. 

Gasoline type: California Air Resources Board (CARB) gasoline with 2% 
Methyl Tertiary Butyl Ether (MTBE) as oxygenate[C]; 
Cents-per-gallon increases for unbranded gasoline types: 3.2; 
Cents-per-gallon increases for branded gasoline types: [Empty]; 
Locations that require this gasoline type: California; 
Time period sold: Beginning of study period (January 2002) to November 
2003. 

Gasoline type: CARB with no oxygenate; 
Cents-per-gallon increases for unbranded gasoline types: 10.1; 
Cents-per-gallon increases for branded gasoline types: [Empty]; 
Locations that require this gasoline type: None, although 
found in California[C]; 
Time period sold: Beginning of study period to May 2006. 

Gasoline type: Conventional with 5.7% ethanol as oxygenate; 
Cents-per-gallon increases for unbranded gasoline types: 4.1; 
Cents-per-gallon increases for branded gasoline types: 1.3; 
Locations that require this gasoline type: Pima County, (Tucson) AZ; 
Time period sold: Winters, from beginning of study period to present. 

Gasoline type: CARB with 5.7% ethanol as oxygenate; 
Cents-per-gallon increases for unbranded gasoline types: [Empty]; 
Cents-per-gallon increases for branded gasoline types: 1.4; 
Locations that require this gasoline type: California; 
Time period sold: Beginning of study period to present. 

Gasoline type: Conventional with 10% ethanol as oxygenate, 7.0 RVP; 
Cents-per-gallon increases for unbranded gasoline types: 8.0; 
Cents-per-gallon increases for branded gasoline types: [Empty]; 
Locations that require this gasoline type: Clay, Jackson, and Platte 
counties, MO; 
Time period sold: Summers, from June 2004 to present. 

Gasoline type: Conventional with 10% ethanol as oxygenate, 9.0 RVP; 
Cents-per-gallon increases for unbranded gasoline types: [Empty]; 
Cents-per-gallon increases for branded gasoline types: 1.5; 
Locations that require this gasoline type: Iowa, Minnesota, many parts 
of Oregon; 
Time period sold: Sold year round in Iowa, and in the summer in all 
other locations; used since the beginning of study period to present. 

Gasoline type: Low sulfur; 
Cents-per-gallon increases for unbranded gasoline types: 3.9; 
Cents-per-gallon increases for branded gasoline types: [Empty]; 
Locations that require this gasoline type: Georgia; 
Time period sold: April 2003 to present. 

Gasoline type: Reformulated gasoline (RFG); 
Cents-per-gallon increases for unbranded gasoline types: 1.3; 
Cents-per-gallon increases for branded gasoline types: 0.9; 
Locations that require this gasoline type: Numerous cities, counties, 
states; 
Time period sold: Beginning of study period to present. 

Source: GAO analysis of data from various sources, as described in 
appendixes I and II. 

Note: All reported figures are statistically significant at the 10 
percent level or less. 

[A] Price increases for special blends include the base case increases 
of 0.5 and .02 for unbranded and branded fuel types respectively. We 
calculated price effects using our model estimates of the impact of 
outages on wholesale gasoline prices. 

[B] Conventional gasoline used as the base case is gasoline that does 
not have a special RVP or oxygenate content specified to meet local air 
quality needs or preferences. 

[C] Although Methyl Tertiary Butyl Ether (MTBE) was not specifically 
required to be the oxygenate used in California, an oxygenate was 
required under federal RFG provisions. The use of MTBE was banned in 
California on December 31, 2003. Following the phase out of MTBE and 
the transition to ethanol, according to California Energy Commission 
(CEC), California refiners and gasoline marketers began using ethanol 
at a minimum concentration of 5.7 percent by volume. Although nearly 20 
percent of the gasoline sold could have been non-oxygenated, according 
to the CEC, due to segregation limitations in the distribution 
infrastructure system and concerns about maintaining fungible gasoline 
production for purposes of exchange agreements and periodic unplanned 
refinery outages, the gasoline market gravitated towards a near- 
unanimous mix of ethanol at roughly 6 percent volume by January 2004. 

TABLE_END

TABLE_2_TEXT = <<TABLE_END
Table 2: Special Fuel Blends that Experienced Price Increases About the 
Same as Conventional Clear Gasoline in the Event of Unplanned Refinery 
Outages: 

Fuel type: Conventional; base case; 
Locations that require this gasoline type: Numerous cities, counties, 
and states; 
Time period sold: Throughout the time period. 

Fuel type: Cleaner burning gasoline (CBG); 
Locations that require this gasoline type: Maricopa County (Phoenix), 
Arizona; 
Time period sold: March 2005 to present. 

Fuel type: CBG with 10% ethanol as oxygenate; 
Locations that require this gasoline type: Maricopa County (Phoenix), 
Arizona--winters; 
Time period sold: February 2005 to present. 

Fuel type: Conventional RVP 7.0; 
Locations that require this gasoline type: Jefferson and Shelby 
counties, Alabama; Johnson and Wyandotte Counties, Kansas; Livingston, 
Macomb, Monroe, Oakland, St. Clair, Washtenaw, Wayne, and Lenawee 
counties Michigan; El Paso, Texas; 
Time period sold: Summers only, from the beginning of study period to 
present. 

Fuel type: Conventional RVP 7.8; 
Locations that require this gasoline type: Numerous cities, counties, 
and states; 
Time period sold: Beginning of study period to present. 

Fuel type: Conventional RVP 9.0; 
Locations that require this gasoline type: Numerous cities, counties, 
and states; 
Time period sold: Beginning of study period to present. 

Fuel type: Conventional 7.7% ethanol as oxygenate; 
Locations that require this gasoline type: Although not required in any 
location, this gasoline occurs frequently in Iowa and Minnesota; and 
the cities of El Paso, Texas; Missoula, Montana; Fargo, North Dakota; 
and Sparks/Reno, Nevada; 
Time period sold: Beginning of study period to present. 

Fuel type: Conventional 7.7% ethanol as oxygenate, RVP 9.0; 
Locations that require this gasoline type: Although not required in any 
location, this gasoline occurs frequently in numerous cities, counties, 
and states; 
Time period sold: Beginning of study period to present. 

Fuel type: Conventional 10% ethanol as oxygenate; 
Locations that require this gasoline type: Numerous cities, counties, 
and states; 
Time period sold: Beginning of study period-present. 

Fuel type: Conventional 10% ethanol as oxygenate, RVP 7.8; 
Locations that require this gasoline type: Denver and Boulder, 
Colorado; Clackamas, Marion, Multnomah, Polk, and Washington counties, 
Oregon; 
Time period sold: Summers, beginning May 2004 in CO; May 2005 in OR 
counties. 

Fuel type: Low Sulfur RVP 7.0; 
Locations that require this gasoline type: Atlanta and 45 other 
counties in Georgia; 
Time period sold: Summer, since April 2003. 

Fuel type: Reformulated Gasoline with Methyl Tertiary Butyl Ether 
(MTBE) as oxygenate; 
Locations that require this gasoline type: Numerous cities, counties, 
and states; 
Time period sold: Beginning of study period to May 2006. 

Source: GAO analysis of data from various sources, as described in 
appendixes I and II. 

TABLE_END

TABLE_1_ROWS = [
  "Gasoline type: Conventional[B] base case; \nCents-per-gallon increases for unbranded gasoline types: 0.5; \nCents-per-gallon increases for branded gasoline types: 0.2; \nLocations that require this gasoline type: Numerous cities, counties, \nand states; \nTime period sold: Throughout the time period. ",
  "Gasoline type: California Air Resources Board (CARB) gasoline with 2% \nMethyl Tertiary Butyl Ether (MTBE) as oxygenate[C]; \nCents-per-gallon increases for unbranded gasoline types: 3.2; \nCents-per-gallon increases for branded gasoline types: [Empty]; \nLocations that require this gasoline type: California; \nTime period sold: Beginning of study period (January 2002) to November \n2003. ",
  "Gasoline type: CARB with no oxygenate; \nCents-per-gallon increases for unbranded gasoline types: 10.1; \nCents-per-gallon increases for branded gasoline types: [Empty]; \nLocations that require this gasoline type: None, although \nfound in California[C]; \nTime period sold: Beginning of study period to May 2006. ",
  "Gasoline type: Conventional with 5.7% ethanol as oxygenate; \nCents-per-gallon increases for unbranded gasoline types: 4.1; \nCents-per-gallon increases for branded gasoline types: 1.3; \nLocations that require this gasoline type: Pima County, (Tucson) AZ; \nTime period sold: Winters, from beginning of study period to present. ",
  "Gasoline type: CARB with 5.7% ethanol as oxygenate; \nCents-per-gallon increases for unbranded gasoline types: [Empty]; \nCents-per-gallon increases for branded gasoline types: 1.4; \nLocations that require this gasoline type: California; \nTime period sold: Beginning of study period to present. ",
  "Gasoline type: Conventional with 10% ethanol as oxygenate, 7.0 RVP; \nCents-per-gallon increases for unbranded gasoline types: 8.0; \nCents-per-gallon increases for branded gasoline types: [Empty]; \nLocations that require this gasoline type: Clay, Jackson, and Platte \ncounties, MO; \nTime period sold: Summers, from June 2004 to present. ",
  "Gasoline type: Conventional with 10% ethanol as oxygenate, 9.0 RVP; \nCents-per-gallon increases for unbranded gasoline types: [Empty]; \nCents-per-gallon increases for branded gasoline types: 1.5; \nLocations that require this gasoline type: Iowa, Minnesota, many parts \nof Oregon; \nTime period sold: Sold year round in Iowa, and in the summer in all \nother locations; used since the beginning of study period to present. ",
  "Gasoline type: Low sulfur; \nCents-per-gallon increases for unbranded gasoline types: 3.9; \nCents-per-gallon increases for branded gasoline types: [Empty]; \nLocations that require this gasoline type: Georgia; \nTime period sold: April 2003 to present. ",
  "Gasoline type: Reformulated gasoline (RFG); \nCents-per-gallon increases for unbranded gasoline types: 1.3; \nCents-per-gallon increases for branded gasoline types: 0.9; \nLocations that require this gasoline type: Numerous cities, counties, \nstates; \nTime period sold: Beginning of study period to present. "
] 

TABLE_2_ROWS = [
  "Fuel type: Conventional; base case; \nLocations that require this gasoline type: Numerous cities, counties, \nand states; \nTime period sold: Throughout the time period. ",
  "Fuel type: Cleaner burning gasoline (CBG); \nLocations that require this gasoline type: Maricopa County (Phoenix), \nArizona; \nTime period sold: March 2005 to present. ",
  "Fuel type: CBG with 10% ethanol as oxygenate; \nLocations that require this gasoline type: Maricopa County (Phoenix), \nArizona--winters; \nTime period sold: February 2005 to present. ",
  "Fuel type: Conventional RVP 7.0; \nLocations that require this gasoline type: Jefferson and Shelby \ncounties, Alabama; Johnson and Wyandotte Counties, Kansas; Livingston, \nMacomb, Monroe, Oakland, St. Clair, Washtenaw, Wayne, and Lenawee \ncounties Michigan; El Paso, Texas; \nTime period sold: Summers only, from the beginning of study period to \npresent. ",
  "Fuel type: Conventional RVP 7.8; \nLocations that require this gasoline type: Numerous cities, counties, \nand states; \nTime period sold: Beginning of study period to present. ",
  "Fuel type: Conventional RVP 9.0; \nLocations that require this gasoline type: Numerous cities, counties, \nand states; \nTime period sold: Beginning of study period to present. ",
  "Fuel type: Conventional 7.7% ethanol as oxygenate; \nLocations that require this gasoline type: Although not required in any \nlocation, this gasoline occurs frequently in Iowa and Minnesota; and \nthe cities of El Paso, Texas; Missoula, Montana; Fargo, North Dakota; \nand Sparks/Reno, Nevada; \nTime period sold: Beginning of study period to present. ",
  "Fuel type: Conventional 7.7% ethanol as oxygenate, RVP 9.0; \nLocations that require this gasoline type: Although not required in any \nlocation, this gasoline occurs frequently in numerous cities, counties, \nand states; \nTime period sold: Beginning of study period to present. ",
  "Fuel type: Conventional 10% ethanol as oxygenate; \nLocations that require this gasoline type: Numerous cities, counties, \nand states; \nTime period sold: Beginning of study period-present. ",
  "Fuel type: Conventional 10% ethanol as oxygenate, RVP 7.8; \nLocations that require this gasoline type: Denver and Boulder, \nColorado; Clackamas, Marion, Multnomah, Polk, and Washington counties, \nOregon; \nTime period sold: Summers, beginning May 2004 in CO; May 2005 in OR \ncounties. ",
  "Fuel type: Low Sulfur RVP 7.0; \nLocations that require this gasoline type: Atlanta and 45 other \ncounties in Georgia; \nTime period sold: Summer, since April 2003. ",
  "Fuel type: Reformulated Gasoline with Methyl Tertiary Butyl Ether \n(MTBE) as oxygenate; \nLocations that require this gasoline type: Numerous cities, counties, \nand states; \nTime period sold: Beginning of study period to May 2006. "
]

TABLE_1_PARSED_ROWS =
[[["Gasoline type", "Conventional[B] base case"],
  ["Cents-per-gallon increases for unbranded gasoline types", "0.5"],
  ["Cents-per-gallon increases for branded gasoline types", "0.2"],
  ["Locations that require this gasoline type",
   "Numerous cities, counties, and states"],
  ["Time period sold", "Throughout the time period"]],
 [["Gasoline type",
   "California Air Resources Board (CARB) gasoline with 2% Methyl Tertiary Butyl Ether (MTBE) as oxygenate[C]"],
  ["Cents-per-gallon increases for unbranded gasoline types", "3.2"],
  ["Cents-per-gallon increases for branded gasoline types", nil],
  ["Locations that require this gasoline type", "California"],
  ["Time period sold",
   "Beginning of study period (January 2002) to November 2003"]],
 [["Gasoline type", "CARB with no oxygenate"],
  ["Cents-per-gallon increases for unbranded gasoline types", "10.1"],
  ["Cents-per-gallon increases for branded gasoline types", nil],
  ["Locations that require this gasoline type",
   "None, although found in California[C]"],
  ["Time period sold", "Beginning of study period to May 2006"]],
 [["Gasoline type", "Conventional with 5.7% ethanol as oxygenate"],
  ["Cents-per-gallon increases for unbranded gasoline types", "4.1"],
  ["Cents-per-gallon increases for branded gasoline types", "1.3"],
  ["Locations that require this gasoline type", "Pima County, (Tucson) AZ"],
  ["Time period sold", "Winters, from beginning of study period to present"]],
 [["Gasoline type", "CARB with 5.7% ethanol as oxygenate"],
  ["Cents-per-gallon increases for unbranded gasoline types", nil],
  ["Cents-per-gallon increases for branded gasoline types", "1.4"],
  ["Locations that require this gasoline type", "California"],
  ["Time period sold", "Beginning of study period to present"]],
 [["Gasoline type", "Conventional with 10% ethanol as oxygenate, 7.0 RVP"],
  ["Cents-per-gallon increases for unbranded gasoline types", "8.0"],
  ["Cents-per-gallon increases for branded gasoline types", nil],
  ["Locations that require this gasoline type",
   "Clay, Jackson, and Platte counties, MO"],
  ["Time period sold", "Summers, from June 2004 to present"]],
 [["Gasoline type", "Conventional with 10% ethanol as oxygenate, 9.0 RVP"],
  ["Cents-per-gallon increases for unbranded gasoline types", nil],
  ["Cents-per-gallon increases for branded gasoline types", "1.5"],
  ["Locations that require this gasoline type",
   "Iowa, Minnesota, many parts of Oregon"],
  ["Time period sold",
   "Sold year round in Iowa, and in the summer in all other locations; used since the beginning of study period to present"]],
 [["Gasoline type", "Low sulfur"],
  ["Cents-per-gallon increases for unbranded gasoline types", "3.9"],
  ["Cents-per-gallon increases for branded gasoline types", nil],
  ["Locations that require this gasoline type", "Georgia"],
  ["Time period sold", "April 2003 to present"]],
 [["Gasoline type", "Reformulated gasoline (RFG)"],
  ["Cents-per-gallon increases for unbranded gasoline types", "1.3"],
  ["Cents-per-gallon increases for branded gasoline types", "0.9"],
  ["Locations that require this gasoline type",
   "Numerous cities, counties, states"],
  ["Time period sold", "Beginning of study period to present"]]
]

TABLE_2_PARSED_ROWS =
[[["Fuel type", "Conventional; base case"],
  ["Locations that require this gasoline type",
   "Numerous cities, counties, and states"],
  ["Time period sold", "Throughout the time period"]],
 [["Fuel type", "Cleaner burning gasoline (CBG)"],
  ["Locations that require this gasoline type",
   "Maricopa County (Phoenix), Arizona"],
  ["Time period sold", "March 2005 to present"]],
 [["Fuel type", "CBG with 10% ethanol as oxygenate"],
  ["Locations that require this gasoline type",
   "Maricopa County (Phoenix), Arizona--winters"],
  ["Time period sold", "February 2005 to present"]],
 [["Fuel type", "Conventional RVP 7.0"],
  ["Locations that require this gasoline type",
   "Jefferson and Shelby counties, Alabama; Johnson and Wyandotte Counties, Kansas; Livingston, Macomb, Monroe, Oakland, St. Clair, Washtenaw, Wayne, and Lenawee counties Michigan; El Paso, Texas"],
  ["Time period sold",
   "Summers only, from the beginning of study period to present"]],
 [["Fuel type", "Conventional RVP 7.8"],
  ["Locations that require this gasoline type",
   "Numerous cities, counties, and states"],
  ["Time period sold", "Beginning of study period to present"]],
 [["Fuel type", "Conventional RVP 9.0"],
  ["Locations that require this gasoline type",
   "Numerous cities, counties, and states"],
  ["Time period sold", "Beginning of study period to present"]],
 [["Fuel type", "Conventional 7.7% ethanol as oxygenate"],
  ["Locations that require this gasoline type",
   "Although not required in any location, this gasoline occurs frequently in Iowa and Minnesota; and the cities of El Paso, Texas; Missoula, Montana; Fargo, North Dakota; and Sparks/Reno, Nevada"],
  ["Time period sold", "Beginning of study period to present"]],
 [["Fuel type", "Conventional 7.7% ethanol as oxygenate, RVP 9.0"],
  ["Locations that require this gasoline type",
   "Although not required in any location, this gasoline occurs frequently in numerous cities, counties, and states"],
  ["Time period sold", "Beginning of study period to present"]],
 [["Fuel type", "Conventional 10% ethanol as oxygenate"],
  ["Locations that require this gasoline type",
   "Numerous cities, counties, and states"],
  ["Time period sold", "Beginning of study period-present"]],
 [["Fuel type", "Conventional 10% ethanol as oxygenate, RVP 7.8"],
  ["Locations that require this gasoline type",
   "Denver and Boulder, Colorado; Clackamas, Marion, Multnomah, Polk, and Washington counties, Oregon"],
  ["Time period sold",
   "Summers, beginning May 2004 in CO; May 2005 in OR counties"]],
 [["Fuel type", "Low Sulfur RVP 7.0"],
  ["Locations that require this gasoline type",
   "Atlanta and 45 other counties in Georgia"],
  ["Time period sold", "Summer, since April 2003"]],
 [["Fuel type",
   "Reformulated Gasoline with Methyl Tertiary Butyl Ether (MTBE) as oxygenate"],
  ["Locations that require this gasoline type",
   "Numerous cities, counties, and states"],
  ["Time period sold", "Beginning of study period to May 2006"]]
]

TABLE_1_DATA =
{:columns=>
  ["Gasoline type",
   "Cents-per-gallon increases for unbranded gasoline types",
   "Cents-per-gallon increases for branded gasoline types",
   "Locations that require this gasoline type",
   "Time period sold"],
 :values=>
  [["Conventional[B] base case",
    "0.5",
    "0.2",
    "Numerous cities, counties, and states",
    "Throughout the time period"],
   ["California Air Resources Board (CARB) gasoline with 2% Methyl Tertiary Butyl Ether (MTBE) as oxygenate[C]",
    "3.2",
    nil,
    "California",
    "Beginning of study period (January 2002) to November 2003"],
   ["CARB with no oxygenate",
    "10.1",
    nil,
    "None, although found in California[C]",
    "Beginning of study period to May 2006"],
   ["Conventional with 5.7% ethanol as oxygenate",
    "4.1",
    "1.3",
    "Pima County, (Tucson) AZ",
    "Winters, from beginning of study period to present"],
   ["CARB with 5.7% ethanol as oxygenate",
    nil,
    "1.4",
    "California",
    "Beginning of study period to present"],
   ["Conventional with 10% ethanol as oxygenate, 7.0 RVP",
    "8.0",
    nil,
    "Clay, Jackson, and Platte counties, MO",
    "Summers, from June 2004 to present"],
   ["Conventional with 10% ethanol as oxygenate, 9.0 RVP",
    nil,
    "1.5",
    "Iowa, Minnesota, many parts of Oregon",
    "Sold year round in Iowa, and in the summer in all other locations; used since the beginning of study period to present"],
   ["Low sulfur", "3.9", nil, "Georgia", "April 2003 to present"],
   ["Reformulated gasoline (RFG)",
    "1.3",
    "0.9",
    "Numerous cities, counties, states",
    "Beginning of study period to present"]]}

TABLE_2_DATA =
{:columns=>
  ["Fuel type",
   "Locations that require this gasoline type",
   "Time period sold"],
 :values=>
  [["Conventional; base case",
    "Numerous cities, counties, and states",
    "Throughout the time period"],
   ["Cleaner burning gasoline (CBG)",
    "Maricopa County (Phoenix), Arizona",
    "March 2005 to present"],
   ["CBG with 10% ethanol as oxygenate",
    "Maricopa County (Phoenix), Arizona--winters",
    "February 2005 to present"],
   ["Conventional RVP 7.0",
    "Jefferson and Shelby counties, Alabama; Johnson and Wyandotte Counties, Kansas; Livingston, Macomb, Monroe, Oakland, St. Clair, Washtenaw, Wayne, and Lenawee counties Michigan; El Paso, Texas",
    "Summers only, from the beginning of study period to present"],
   ["Conventional RVP 7.8",
    "Numerous cities, counties, and states",
    "Beginning of study period to present"],
   ["Conventional RVP 9.0",
    "Numerous cities, counties, and states",
    "Beginning of study period to present"],
   ["Conventional 7.7% ethanol as oxygenate",
    "Although not required in any location, this gasoline occurs frequently in Iowa and Minnesota; and the cities of El Paso, Texas; Missoula, Montana; Fargo, North Dakota; and Sparks/Reno, Nevada",
    "Beginning of study period to present"],
   ["Conventional 7.7% ethanol as oxygenate, RVP 9.0",
    "Although not required in any location, this gasoline occurs frequently in numerous cities, counties, and states",
    "Beginning of study period to present"],
   ["Conventional 10% ethanol as oxygenate",
    "Numerous cities, counties, and states",
    "Beginning of study period-present"],
   ["Conventional 10% ethanol as oxygenate, RVP 7.8",
    "Denver and Boulder, Colorado; Clackamas, Marion, Multnomah, Polk, and Washington counties, Oregon",
    "Summers, beginning May 2004 in CO; May 2005 in OR counties"],
   ["Low Sulfur RVP 7.0",
    "Atlanta and 45 other counties in Georgia",
    "Summer, since April 2003"],
   ["Reformulated Gasoline with Methyl Tertiary Butyl Ether (MTBE) as oxygenate",
    "Numerous cities, counties, and states",
    "Beginning of study period to May 2006"]]}
