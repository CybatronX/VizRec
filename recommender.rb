require 'csv'

# Parse a CSV file with column names.
# The first line of the file is assumed
# to be the column names, and also defines
# the number of columns.  Returns an
# array of hashes.

High	= 4;
Medium	= 2;
Low		= 0;
Never	= -100;

class Dimension
	attr_accessor :Type
	attr_accessor :TextLength
	attr_accessor :Cardinality

	#Type			=	{Geo, Trend, Normal}
	#MaxLength 		= 	{Short, Medium, Long}
	#Cardinality	=	{Low, Medium, High}
end


class InputClass
	attr_accessor :propertyCombinations;
	attr_accessor :numDimensions
	attr_accessor :Dimension1
	attr_accessor :Dimension2
end


def calculateScore(input, visualProperties)
	score = 0;
	score += visualProperties.propertyCombinations[input.propertyCombinations];
		
		if(score == Never)
			return score;
		end


	#if numDimensions is 1 it is simple
	if input.numDimensions == '1'
		score += visualProperties.Dimension1.Type[input.Dimension1.Type];
		score += visualProperties.Dimension1.Cardinality[input.Dimension1.Cardinality];
		score += visualProperties.Dimension1.TextLength[input.Dimension1.TextLength];
	else
	#Else you need to assume both case
		#Assume Dimension1 is category and Dimension2 is series
			tempScoreDimension1		= 0;
			tempScore_Dimension1	=  visualProperties.Dimension1.Type[input.Dimension1.Type];
			tempScore_Dimension1 	+= visualProperties.Dimension1.Cardinality[input.Dimension1.Cardinality]
			tempScore_Dimension1 	+= visualProperties.Dimension1.TextLength[input.Dimension1.TextLength]

			tempScore_Dimension1 	+= visualProperties.Dimension2.Type[input.Dimension2.Type]
			tempScore_Dimension1 	+= visualProperties.Dimension2.Cardinality[input.Dimension2.Cardinality]
			tempScore_Dimension1 	+= visualProperties.Dimension2.TextLength[input.Dimension2.TextLength]

		#Assume Dimension2 is category and Dimension1 is series
			tempScore_Dimension2	= 0;
			tempScore_Dimension2	=  visualProperties.Dimension1.Type[input.Dimension2.Type];
			tempScore_Dimension2 	+= visualProperties.Dimension1.Cardinality[input.Dimension2.Cardinality]
			tempScore_Dimension2 	+= visualProperties.Dimension1.TextLength[input.Dimension2.TextLength]

			tempScore_Dimension2 	+= visualProperties.Dimension2.Type[input.Dimension1.Type]
			tempScore_Dimension2 	+= visualProperties.Dimension2.Cardinality[input.Dimension1.Cardinality]
			tempScore_Dimension2 	+= visualProperties.Dimension2.TextLength[input.Dimension1.TextLength]

		#Find Max Score and add it to the original score
			if tempScore_Dimension1 > tempScore_Dimension2
				score += tempScore_Dimension1;
			else
				score += tempScore_Dimension2;
			end
		end
			return score;
end	

class Bar
	attr_accessor :propertyCombinations;
	attr_accessor :Dimension1
	attr_accessor :Dimension2

	def initialize()
		@propertyCombinations 			= {'1D 1M'=> Low, '1M'=>Low};
		@propertyCombinations.default 	= Never;

		@Dimension1						= Dimension.new
		@Dimension1.Type				= {'Geo'=>Low, 'Trend'=>Low, 'Normal'=>Low}
		@Dimension1.Cardinality			= {'Low' =>Low, 'Medium'=>Low, 'High'=>Low}
		@Dimension1.TextLength			= {'Short'=>Low, 'Medium'=>Low, 'Long'=>Low}

	end
end

class ClusteredBar
	attr_accessor :propertyCombinations;
	attr_accessor :Dimension1
	attr_accessor :Dimension2

	def initialize()
		@propertyCombinations 			= {'1D 2M'=>Low, '1D 3M'=>Low, '1D 4M'=>Low};
		@propertyCombinations.default 	= Never;

		@Dimension1						= Dimension.new
		@Dimension1.Type				= {'Geo'=>Low, 'Trend'=>Low, 'Normal'=>Low}
		@Dimension1.Cardinality			= {'Low' =>Low, 'Medium'=>Low, 'High'=>Low}
		@Dimension1.TextLength			= {'Short'=>Low, 'Medium'=>Low, 'Long'=>Low}

		@Dimension2						= Dimension.new
		@Dimension2.Type				= {'Geo'=>Low, 'Trend'=>Low, 'Normal'=>Low}
		@Dimension2.Cardinality			= {'Low' =>High, 'Medium'=>Medium, 'High'=>Low}
		@Dimension2.TextLength			= {'Short'=>Low, 'Medium'=>Low, 'Long'=>Low}
	end
end

class StackedBar
	attr_accessor :propertyCombinations;
	attr_accessor :Dimension1
	attr_accessor :Dimension2

	def initialize()
		@propertyCombinations 			= {'2D 1M'=>Medium, '1D 2M'=>Low, '1D 3M'=>Low, '1D 4M'=>Low};
		@propertyCombinations.default 	= Never;

		@Dimension1						= Dimension.new
		@Dimension1.Type				= {'Geo'=>Low, 'Trend'=>Low, 'Normal'=>Low}
		@Dimension1.Cardinality			= {'Low' =>Low, 'Medium'=>Low, 'High'=>Low}
		@Dimension1.TextLength			= {'Short'=>Low, 'Medium'=>Low, 'Long'=>Low}

		@Dimension2						= Dimension.new
		@Dimension2.Type				= {'Geo'=>Low, 'Trend'=>Low, 'Normal'=>Low}
		@Dimension2.Cardinality			= {'Low' =>High, 'Medium'=>Medium, 'High'=>Low}
		@Dimension2.TextLength			= {'Short'=>Low, 'Medium'=>Low, 'Long'=>Low}
	end
end

class Line
	attr_accessor :propertyCombinations;
	attr_accessor :Dimension1
	attr_accessor :Dimension2

	def initialize()
		@propertyCombinations 			= {'1D 1M'=>Medium, '2D 1M'=>Medium, '1D 2M'=>Medium, '1D 3M'=>Medium, '1D 4M'=>Medium, '1D 5M'=>Low};
		@propertyCombinations.default 	= Never;

		@Dimension1						= Dimension.new
		@Dimension1.Type				= {'Geo'=>Low, 'Trend'=>High, 'Normal'=>Low}
		@Dimension1.Cardinality			= {'Low' =>Low, 'Medium'=>Low, 'High'=>Low}
		@Dimension1.TextLength			= {'Short'=>Low, 'Medium'=>Low, 'Long'=>Low}

		@Dimension2						= Dimension.new
		@Dimension2.Type				= {'Geo'=>Low, 'Trend'=>Low, 'Normal'=>Low}
		@Dimension2.Cardinality			= {'Low' =>High, 'Medium'=>Medium, 'High'=>Low}
		@Dimension2.TextLength			= {'Short'=>Low, 'Medium'=>Low, 'Long'=>Low}
	end
end

class Pie
	attr_accessor :propertyCombinations;
	attr_accessor :Dimension1
	attr_accessor :Dimension2

	def initialize()
		@propertyCombinations 			= {};
		@propertyCombinations.default 	= Never;

		@Dimension1						= Dimension.new
		@Dimension1.Type				= {'Geo'=>High, 'Trend'=>Low, 'Normal'=>Low}
		@Dimension1.Cardinality			= {'Low' =>Low, 'Medium'=>Low, 'High'=>Low}
		@Dimension1.TextLength			= {'Short'=>Low, 'Medium'=>Low, 'Long'=>Low}

		@Dimension2						= Dimension.new
		@Dimension2.Type				= {'Geo'=>Low, 'Trend'=>Low, 'Normal'=>Low}
		@Dimension2.Cardinality			= {'Low' =>High, 'Medium'=>Medium, 'High'=>Low}
		@Dimension2.TextLength			= {'Short'=>Low, 'Medium'=>Low, 'Long'=>Low}
	end
end

class Map
	attr_accessor :propertyCombinations;
	attr_accessor :Dimension1
	attr_accessor :Dimension2

	def initialize()
		@propertyCombinations 			= {'1D 1M'=>Medium, '2D 1M'=>Medium};
		@propertyCombinations.default 	= Never;

		@Dimension1						= Dimension.new
		@Dimension1.Type				= {'Geo'=>High, 'Trend'=>Low, 'Normal'=>Low}
		@Dimension1.Cardinality			= {'Low' =>Low, 'Medium'=>Low, 'High'=>Low}
		@Dimension1.TextLength			= {'Short'=>Low, 'Medium'=>Low, 'Long'=>Low}

		@Dimension2						= Dimension.new
		@Dimension2.Type				= {'Geo'=>Low, 'Trend'=>Low, 'Normal'=>Low}
		@Dimension2.Cardinality			= {'Low' =>High, 'Medium'=>Medium, 'High'=>Low}
		@Dimension2.TextLength			= {'Short'=>Low, 'Medium'=>Low, 'Long'=>Low}
	end
end

class Scatter
	attr_accessor :propertyCombinations;
	attr_accessor :Dimension1
	attr_accessor :Dimension2

	def initialize()
		@propertyCombinations 			= {'1D 2M'=>High, '1D 3M'=>High, '2D 2M'=>High, '2D 3M'=>High};
		@propertyCombinations.default 	= Never;

		@Dimension1						= Dimension.new
		@Dimension1.Type				= {'Geo'=>Low, 'Trend'=>Low, 'Normal'=>Low}
		@Dimension1.Cardinality			= {'Low' =>Low, 'Medium'=>Low, 'High'=>Low}
		@Dimension1.TextLength			= {'Short'=>Low, 'Medium'=>Low, 'Long'=>Low}

		@Dimension2						= Dimension.new
		@Dimension2.Type				= {'Geo'=>Low, 'Trend'=>Low, 'Normal'=>Low}
		@Dimension2.Cardinality			= {'Low' =>High, 'Medium'=>Medium, 'High'=>Low}
		@Dimension2.TextLength			= {'Short'=>Low, 'Medium'=>Low, 'Long'=>Low}
	end
end









#columns, inputData = csv("C:/Users/ajayan/Work/Work/Chart Recommendation/data.csv");
#puts inputData[0]['Property Comibination']

inputFile = File.read('C:/Users/ajayan/Work/Work/Chart Recommendation/data.csv')
inputFileReader = CSV.parse(inputFile, :headers => true)

CSV.open('C:/Users/ajayan/Work/Work/Chart Recommendation/output.csv', "wb") do |output|
  

	inputFileReader.each do |row|                                       
	    

	    puts "#{row['Property Combination']};#{row['Num Dimensions']};#{row['D1.Type']};#{row['D1.Cardinality']};#{row['D1.Textlength']};#{row['D2.Type']};#{row['D2.Cardinality']};#{row['D2.Textlength']};#{row['Expected Output']};#{row['Current Output']}; "

	    input = InputClass.new;
		input.propertyCombinations 		= row['Property Combination'];
		input.numDimensions 			= row['Num Dimensions'];

		input.Dimension1 				= Dimension.new
		input.Dimension1.Type			= row['D1.Type'];
		input.Dimension1.Cardinality	= row['D1.Cardinality'];
		input.Dimension1.TextLength		= row['D1.Textlength'];

		input.Dimension2 				= Dimension.new
		input.Dimension2.Type			= row['D2.Type'];
		input.Dimension2.Cardinality	= row['D2.Cardinality'];
		input.Dimension2.TextLength		= row['D2.Textlength'];

		currentBar			= Bar.new;
		currentClusteredBar = ClusteredBar.new;
		currentStackedBar	= StackedBar.new;
		currentScatter		= Scatter.new;
		currentMap			= Map.new;
		currentPie			= Pie.new;
		currentLine			= Line.new;

		puts " Bar: #{calculateScore(input,currentBar)}"
		puts " Clustered Bar: #{calculateScore(input,currentClusteredBar)}";
		puts " Stacked Bar: #{calculateScore(input,currentStackedBar)}";
		puts " Scatter: #{calculateScore(input,currentScatter)}";
		puts " Line: #{calculateScore(input,currentLine)}";
		puts " Map: #{calculateScore(input,currentMap)}";

		scoreHash = {'Bar'=>calculateScore(input,currentBar), 'Clustered Bar'=>calculateScore(input,currentClusteredBar), 'Stacked Bar'=> calculateScore(input,currentStackedBar), 'Scatter'=> calculateScore(input,currentScatter), 'Line'=> calculateScore(input,currentLine), 'Map'=>calculateScore(input,currentMap)};
		
		maxScore 				= scoreHash.values.max;
		outputVisual 			= Hash[scoreHash.select { |k, v| v == maxScore}].first[0];
		outputVisualScore		= Hash[scoreHash.select { |k, v| v == maxScore}].first[1];

		output << [row['Property Combination'], row['Num Dimensions'], row['D1.Type'], row['D1.Cardinality'], row['D1.Textlength'], row['D2.Type'], row['D2.Cardinality'], row['D2.Textlength'], row['Expected Output'], outputVisual, outputVisualScore]
	end

end













