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


In order to implement an early failure policy to raise exceptions yourself.
```ruby
    ArgumentError.assert.raised? do
      ihash =
        IHash.new
          .set_constraints\
            a: ->(value){ value == 42 or raise ArgumentError }

      ihash.set_values a: 41
    end
```

Oh and I am so glad you asked, before setting values, constraints are not enforced and
the instance is therefore valid:

```ruby
    ihash = IHash.new.set_constraints \
      a: ->{ raise ArgumentError },
      b: ->{ false }

    ihash.valid?.assert == true
    ihash.set_values b: nil
    ihash.valid?.assert == false

    ArgumentError.assert.raised? do
      ihash.set_values a: nil
    end
```

So far everything was very easy, but now we need to consider, how caching, constraints and logic work together

## Caching

Let us at first verify that caching does the right thing.

With right thing we mean that we we cache all values that
are computed. We do not cache values that are in the defaults hash, nor
values that are in the values hash. And when we access a value with
a default parameter in `get` it will not be cached either.

This way, `get` will behave like a pure function.

```ruby
    ihash = IHash.new \
      a: ->{ get :a, 42 }, 
      b: ->{ get( :a, 41 ) + 1 }

    #  Default param in get( :a, 41 ) is triggered but not cached
    ihash.get( :b ).assert == 42
    ihash.get( :a ).assert == 42

    # Invalidate the cache so that b is not
    # cached. We will cache a again
    ihash.get( :a ).assert == 42
    # But default params in get have higher priorities
    ihash.get( :b ).assert == 42
  
  
    ihash.set_values
    ihash.get( :b ).assert == 42
    ihash.get( :a ).assert == 41
```
  
However, the default parameter inside `get` is not cached itself, proof:

```ruby
    ihash.set_values
    ihash.get( :a, nil ).assert == nil
    ihash.get( :b ).assert == 42
    ihash.get( :a, nil ).assert == 41
```


This behavior might change with minor version updates as it is not very
intuitive.

Now that we are aware how caching and default values work let us go further with constraints
