**Introduction to Ruby Notes**

Compiled by Conrad Benham

Ruby:
* is dynamically typed
* is object oriented
* is garbage Collected
* has duck typing
* was conceived in 1993 by Yukihiro Matsumoto (“Matz”)
* latest version as of 5/4/2015: 2.2.2
* version 3 is on the horizon

Ruby, does not depend on the indentation level of the code, instead it uses the keyword “end” to denote the end of a structure.

**Comments**

There are two styles of comment in Ruby:

* single line:
		
		def some_method_with_a_comment
			#This is a single line comment
		end
	
* multi-line:

		class AClass
			def some_method_with_comment
		=begin
				This is a multi-line comment.
				The comment starts with =begin and is terminated with =end.
				Both the =begin and the =end must be up against the very left of the file.
		=end
			end
		end

**Naming Conventions**

Different languages have their own standard practices for naming conventions. In Ruby classes are generally in camel case in which the first letter of each word in the name is capitalised as in `CustomerInvoice`. Methods and variables are defined using snake case: `print_invoice`. An underscore is used to separate the words that compose the name of the method or variable.

It is common to use `?` or `!` on certain methods too. Question mark characters are often used at the end of a method that returns a boolean value: `invoice_fulfilled?`. Exclamation marks are generally used as a caution to indicate that a method will cause a side effect of some kind: `cancel_invoice!`.


**Method Dclaration**

Methods are declared using the `def` keyword followed by the snake case method name and ended with the `end` keyword. For example:

	def square(number)
		return number * number
	end

The parentheses are optional, so the following also works:

	def square number
		return number * number
	end
	
The method may be invoked as follows: `square(4)` or `square 4` both are equivalent and will lead to the result of 16.

Methods in Ruby will by default always return the value of the last invoked statement. For example `square` could be rewritten as follows:

	def square(number)
		number * number
	end
	
The result of `number * number` will be returned by the method as it is the last expression in the method.
		

**Symbols**

Ruby has the concept of symbols. Symbols are constructs that are often used for meta-programming. They begin with a colon (:), the first character after the colon must be a letter which may then be followed by letters or numbers, such as:

* :age
* :name
* :country

Symbols as well as strings are commonly used as keys in maps.

**Class Definitions**

Classes are declared using the `class` keyword, the camel case class name, ended with the `end` keyword.

	class Customer
	end

Classes may have constructors, otherwise known as initializers:

	class Customer
		def initialize()
		end
	end
	
Objects are created using constructors with the following syntax:

	Customer.new

Constructors may have arguments passed to them, which can be assigned to class attributes:

	class Customer
		def initialize(name, country)
			@name = name
			@country = country
		end
	end

The `@` symbol is prepended to the name of the attribute and makes it an object variable. The attributes 'name' and 'country' are *private* to the class and cannot be accessed outside of the class, without using some form of meta-programming which won’t be addressed here. To make attributes accessible outside of an object the following can be used:

* attr_reader – creates a public read method for the given attribute
* attr_writer – creates a public write method for the given attribute
* attr_accessor – creates a public read and write method for the given attribute, this would be the equivalent of using attr_reader and attr_writer at the same time.

Example (note that `puts` prints to the console):

	class Customer
		attr_reader :name
		attr_accessor :country
		
		def initialize(name, country)
			@name = name
			@country = country
		end
	end

	c = Customer.new("Sara", "USA")
	puts c.name # => Sara
	puts c.country # => USA
	c.country = 'United States of America'
	puts c.country # => United States of America
	c.name = 'Sarah" # => NoMethodError: undefined method 'name=' for...

The attr_reader, attr_writer and attr_accessor methods are class methods. That is, they are defined at the class level and are not defined on instances of the class Customer.
	

**Class Inheritance**

Like other languages, Ruby supports inheritance and even goes one step further to support multiple inheritance. Here's an example of inheritance in Ruby:

	class GasVehicle
		#Logic goes here...
	end
	
	class Car < GasVehicle
	end
	
	class Truck < GasVehicle
	end
	
To indicate that a class should inherit from another class, the less than sign '<' is used. All public methods in the super classes are available to the subclass to invoke.

Multiple inheritance is supported as follows:

	class ElectricVehicle
	end
	
	class HybridVehicle < GasVehicle, ElectricVehicle
	end
	
Multiple inheritance is specified by simple using a comma separated set of super classes.

**Invoking super class methods**

A method on a super class may be invoked as follows:

	class Vehicle
		MILES_PER_GALLON = 20
		GALLONS_HELD_IN_GAS_TANK = 200
	
		def initialize
			@fuel_level_percentage = 100
		end
	
		def drive(miles)
			@fuel_level_percentage -= GALLONS_HELD_IN_GAS_TANK / miles / MILES_PER_GALLON * 100
		end
	end
	
	class DilapidatedTruck
		def initialize
			@wear_and_tear_percentage = 50
		end
		
		def drive(miles)
			super(miles)
			@wear_and_tear_percentage -= 1
		end
	end
	
	DilapidatedTruck.new.drive(40) # @fuel_level_percent drops to 75% and wear_and_tear_percentage drops to 49%
			
DilapidatedTruck#drive overrides the drive method of the Vehicle superclass. The call to `super` by DilapidatedTruce causes the Vehicle#drive to be invoked. Without that call, the fuel level percentage would remain unchanged.
	
**Conditionals**

Like other languages Ruby supports if/else if/else constructs:
Single conditional statements are constucted using the `if` statement:

	if price > account_balance
		puts "You don't have enough money to complete this purchase"
	end
	
Conditionals with multiple branches appear as follows:

	if price == account_balance
		puts "You can complete this transaction and will have no money left afterwards"
	elsif price < account_balance
		puts "You can complete this transaction"
	else
		puts "You don't have enough funds to complete this transaction"
	end

Ruby supports one line conditionals. In the following example, the method returns true early if there are enough funds available. If there are not the method prints a message and return false.

	def has_available_funds?(price, account_balance)
		return true if price < account_balance
		puts "You don't have enough funds to complete this transaction"
		false
	end
	
**Duck Typing**

Ruby does not keep track of the types of objects that are passed from one object to another. That's to say that regardless of the type of an object it can be passed to methods of other objects without care for the type of the passed object. Ruby only expects that an object respond to a method call and that it accepts the arguments that are passed to it.

	 class Car
	 	def initialize
	 		@fuel_level_percentage = 50
	 	end
	 
	 	def fuel_up
	 		@fuel_level_percentage += 10
	 	end
	 end
	 
	 class Person
	 	def initialize
	 		@calories = 2000
	 
	 	def fuel_up
	 		@calories += 500
	 	end
	 end
	 
	 class Sustainable
	 	def provide_sustenance(depletable)
	 		depletable.fuel_up
	 	end
	 end
	 
	 car = Car.new
	 person = Person.new
	 sustainable = Sustainable.new
	 
	 sustainable.provide_sustenance car # @fuel_level_percentage becomes 60
	 sustainable.provide_sustenance person # @calories becomes 2500
	 	
In both cases, the car increases the amount of fuel it has and the person receives more calories. It does not matter that the types of the two classes are different, the method 'provide_sustenance' can be invoked on both objects. Merely from the fact the method exists on both classes.
		
**unless**

In many languages, when we want to test the negation of a value we write:

	if !customer.has_available_credit?
		puts "Sorry, you don't have enough money to complete this transaction"
	end
	
In Ruby we are able to write the same expression without the `!`:

	unless customer.has_available_credit?
		puts "Sorry, you don't have enough money to complete this transaction"
	end
	
In this second example, the statement will not be printed out if the customer has credit. The statement may also be written using a one line conditional:

	puts "Sorry, you don't have enough money to complete this transaction" unless customer.has_available_credit?

**nil**

Many languages have the concept of no value or null. In Ruby the equivalent is `nil`.


**Truthiness and Falsiness**

Values in Ruby have what is known as truthiness and falsiness. Values may be evaluated to see if they are true or false. Non-nil values are considered truthy while nil values are considered falsy. This can be useful when evaluating expressions to determine what value to assign. A common Ruby idiom is to assign a default value in the case a variable is nil:

	price = price || 99
	
In this example, the price will keep its value if it has one or will be assigned the 99 in the case that price is nil.

Truthiness and falsiness testing can also be used in conjunction with if/unless/else/elsif conditionals:

	unless price
		puts "Price check please!"
	end
	

**Strings**


Strings in Ruby may be declared using single and double quotes. The following are identical strings:

	"This is a string" == 'This is a string' # => true


One version has distinct advantages over the other depending on the circumstance:

* Embedding quotes in the string. Depending on the type of the quote you want to embed, create a string using the opposite quote type as in:

		"It's yours!" #Avoids escaping: 'It\'s yours!'
	or
		
		'"Can we go to the park?" she asked.' #Avoids escaping: "\"Can we go to the park?\" she asked."
		
* When special characters are to be embedded such as new lines or tabs, double quoted strings must be used:

		puts "This string spans\ntwo lines and \t has a tab"

	Generates:
	
	<pre>
	This string spans
	two lines and     has a tab
	</pre>
	
**String Interpolation**

Sometimes it is helpful to embed a string representation of a variable inside a string. In Ruby and many other languages this can be achieved as follows:

	number_of_parked_cars = 55
	"There are " + number_of_parked_cars.to_s + " cars in the lot, we are at capacity!"
	
An alternative is to use string interpolation as follows:

	number_of_parked_cars = 55
	"There are #{number_of_parked_cars} cars in the lot, we are at capacity!"
	
The variable to be included in the string begins with '#{' and is terminated with '}'.

Note that in this interpolation case the variable 'number_of_parked_cars' is automatically converted to a string. In Ruby it is generally preferred that string interpolation be used over concatenation.

**Exception Hierarchy**

Ruby has an exception hierarchy. At the top of the hierarchy is the `Exception` class. The following shows a hierarchy for some exceptions:

	Exception
	    => StandardError
	            => ArgumentError
	            => IndexError
	            => IOError
	            => RangeError
	            => RegexError
	            => RuntimeError
	            => ThreadError
	            => ZeroDivisionError
	            => NameError
	                => NoMethodError

**Application Exceptions**

The following syntax is used to define an application exception:

	class OverheatedException < Exception
		def initialize(temperature)
			super("Overheated at #{temperature} degrees")
		end
	end

This defines an OverheatedException whose superclass is Exception. The call to `super` passes the string to the Exception superclass as the message. The message can be retrieved by calling the `message` method: `OverheatedException.new(99).message`

**Catching exceptions**

Exceptions can be caught (or, in Ruby parlance, rescued):

	begin
		4/0 #Causes a 
	rescue
		puts 'Oops something went wrong here'
	end
 
In this case a ZeroDivisionError was raised and handled by the rescue clause. Actually, any error or exception that was raised in the `begin/rescue` block would be caught.

Specific exceptions can be handled by specifying the type of the exception to catch in the rescue clause:

	begin
		4/0
	rescue ZeroDivisionError => e
		puts e.message
	end
	
In this variant, only the ZeroDivisionError would be caught and handled. Any other exception that might be raised would not be rescued and would bubble down the stack until something rescues it.
	

**Ensuring evaluation**

To ensure some code is always evaluated regardless of whether an exception is raised or not, `ensure` is used:

	begin
		#Some code
	ensure
		puts "Now that we are finished, we may clean up"
	end

Ensure may be used in conjunction with a rescue but does not need to be, as shown in the example.
	
**Blocks**

It is common, when programming, to encounter boilerplate code that really only gets in the way of doing what we care to achieve. Take writing to a file as an example. First, one must open a stream to the file, write to it and finally close it (in the following case the close method will also flush the stream). The basic approach might be as follows:
	
	#First argument: name of file. Second argument: specifies file may be written to.
	begin
		stream = File.open('path/to/file', 'w')
		stream.write('Some text is going into the file')
	ensure
		stream.close if stream
	end
	
Here, the file is opened, written to and finally closed if it was successfully opened. In the case the file could not be opened, the ensure clause would not attempt to close the stream.

An approach that would remove the code that could be considered boiler plate might look like this:

	def write_to_file(name_of_file)
		begin
			stream = File.open('path/to/file', 'w')
			yield(stream)
		ensure
			stream.close if stream
		end
	end
	
	write_to_file('path/to/file') do |stream|
		stream.write('Some text is going into the file')
	end
	
In this second implementation, a `block` is passed to the 'write_to_file' method. The block specifies custom logic that is to be invoked when the stream has been opened. The block is composed of the following syntax:

* do - opens the block
* |stream| - specifies the argument passed to the block. In this case the block is given a single argument and must be configured to accept such an argument. Blocks don't have to take arguments and they may take more than argument. When given more than a single argument, the arguments are separatated by commas, much like the arguments passed to a method.
* end - denotes the end of the block.

You might have noticed, the `yield` statement in the 'write_to_file' method. The yield statement is used to invoke the block. In this case the block will be invoked with the stream. This is how the stream argument is passed to the block. Note that the parentheses are optional. The block could be yielded to using `yield stream`.

Having shown the implementation of this, Ruby's File class actually supports something similar to what was implemented above.

	File.open('path/to/file', 'w') do |stream|
		stream.write('Some text is going into the file")
	end

**Arrays**

Like other languages, Ruby has zero index based Arrays. A new Array can be created using the following syntax:

* `[]` #Creates an empty array. The syntax is '[' followed by ']'
* `[1, 2, 3]` #Creates a new array filled with the numbers 1, 2 and 3
* `Array.new` #Creates an empty array

Below are some helpful methods that exist on Array:

* `[]`

Retrieves the item at the given index in the array:

	[4, 5, 6][0] # => 4
	[4, 5, 6][3] # => nil
	[4, 5, 6][-1] # => 6
	[4, 5, 6][-2] # => 5
	
* each
* map
* select
* reject
* compact

Returns an array with all nil values removed. `[1, nil, 2, nil, 3].compact` returns `[1, 2, 3]`

* size

Returns the number of elements in the array.

* empty?

Returns true if the array is empty or false otherwise.

* flatten

Returns a new array with all nested arrays recursively removed and the elements brought into the current array.

`[1, [2, 3, [4, 5], 6], 7].flatten` returns `[1, 2, 3, 4, 5, 6, 7]`

* join

Creates a string of each element in the array joined together. [`1, 2, 3].join(' & ')` returns `'1 & 2 & 3'`

* reverse

Reverses the order of an array: `[1, 2, 3, 4, 5].reverse` returns `[5, 4, 3, 2, 1]`

* sort

Returns a new array with all items in sort order: `[3, 4, 2, 1, 5].sort` returns `[1, 2, 3, 4, 5]`

* uniq

Removes subssequent duplicates: `[1, 2, 3, 4, 2, 5].uniq` returns `[1, 2, 3, 4, 5]`

**Hashes**

* []
* size
* each
* each_key
* each_value
* empty?
* has_key?
* merge
* select



	


