# DynaStruct

DynaStruct offers a number of classes which provide different ways to dynamically assign and interact with instance variables.
This is accomplished through Ruby's metaprogramming, which allows the dynamic manipulation of data and methods for a specific object.

## Installation

Add this line to your application's Gemfile:

    gem 'dyna_struct'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dyna_struct

## Usage

The DynaStruct module provides four classes, offering different degrees of complexity:

* `DynaStruct::Base`
* `DynaStruct::Reader`
* `DynaStruct::Accessor`
* `DynaStruct::Full`

`DynaStruct::Base` contains only an initialize method, which takes a Hash and dynamically defines instance variables based on the values provided. So,

    DynaStruct::Base.new(foo: 'bar')

will yield a new object with instance variable `@foo = 'bar'`.

`DynaStruct::Reader` offers this same functionality, with the addition of reader methods for instance variables.

    x = DynaStruct::Reader.new(foo: 'bar)
    x.foo   #=> 'bar'

Similarly, `DynaStruct::Accessor` adds both getter and setter methods:

    y = DynaStruct::Accessor.new(foo: 'bar')
    x.foo = 7
    x.foo   #=> 7

`DynaStruct::Full` offers all of the above features, as well as most of the features offered by Ruby's OpenStruct class.

    z = DynaStruct::Full.new(foo: 'bar')
    z[:foo]   #=> 'bar'
    z['abc'] = 'def'
    z.abc   #=> 'def'
    z.to_h   #=> { foo: 'bar', abc: 'def' }

DynaStruct also offers a `DynaStruct::Modifiable` module, which adds three classes:

* `DynaStruct::Modifiable::Base`
* `DynaStruct::Modifiable::Reader`
* `DynaStruct::Modifiable::Accessor`

These classes correspond to the above classes, but add 3 methods: `.<<`, `.remove`, and `.empty?`,
which allow the user to make some modifications to the object after instantiation.

    x = DynaStruct::Modifiable::Reader.new
    x.empty?   #=> true
    x << { abc: 'def' }
    x.empty?   #=> false
    x.abc   #=> 'def'
    x.remove(:abc)   #=> 'def'
    x.empty?   #=> true

* * *

The biggest advantage these classes have over Ruby's OpenStruct is inheritance.

    class Foo < DynaStruct::Reader; end

defines a class that can be initialized with an arbitrary Hash and automagically possess instance variables and reader methods corresponding to that Hash.

## Contributing

1. Fork it ( http://github.com/xDAGRONx/dyna_struct/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request