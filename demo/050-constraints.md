# IHash QED

## Constraints

Constraints are evaluated whenever the values of an `IHash` instance are set via the `set_values` method.

The result of this evaluation is stored for later validation. 

Let us dive into a simple example:

```ruby
    ihash = IHash.new
      .set_constraints( 
        a: ->(eventual_value_for_a){ eventual_value_for_a == 42 } )
      .set_values a: 43

    ihash.valid?.assert == false
    ihash.errors.empty?.assert == false
    ihash.errors.first.assert =~ /value error for key :a and value 43/

    ihash.set_values a: 42
    ihash.valid?.assert == true
    ihash.errors.empty?.assert == true
    
```

In order to implement an early failure policy you need to raise exceptions yourself.

```ruby
    ArgumentError.assert.raised? do
      ihash =
        IHash.new
          .set_constraints\
            a: ->(value){ value == 42 or raise ArgumentError }

      ihash.set_values a: 41
    end
```

Maybe a `set_constraints!` method doing something like that for you can be
implemented later on.

Oh and I am so glad you asked, before setting values, constraints are not enforced and
the instance is therefore valid in all cases:

```ruby
    ihash = IHash.new( a: nil ).set_constraints a: ->{ raise ArgumentError }

    ihash.valid?.assert == true

    ArgumentError.assert.raised? do
      ihash.set_values b: nil
    end
    ihash.valid?.assert == false
    ihash.errors.first.assert == 'constraint for key :a raised an error ArgumentError'
```

And this works for calculated values too, of course:

```ruby
    ihash = IHash
      .new( a: ->{ - get( :b ) } )
      .set_constraints( a: ->(val){ val > 0 } )
      .set_values b: 42

    ihash.valid?.assert == false
    
```


