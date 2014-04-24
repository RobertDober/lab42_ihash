# IHash QED

## Introduction

An `IHash` is an object that lets us define an _intelligent_ way to access a Hash like object.


The services `IHash` provides are of the number of four:

* Default values per key.
* Validation via _Constraints_.
* Business Logic or Lookup Logic.
* Caching of Computed Values.

## Defaults


### Predefined

The simplest meaningful example could look like the following:

```ruby
    ihash = IHash.new a: 1, b: 2

    ihash.get( :a ).assert == 1
    ihash.get( :b ).assert == 2
    ihash.set_values a: 42
    ihash.get( :a ).assert == 42
    # Defaults are not changed:
    ihash.get( :b ).assert == 2
```

Alternatively the `set_defaults` method can be used:

```ruby
    ihash.set_defaults a: 1, c: 2
    # values are not touched
    ihash.get( :a ).assert == 42
    # new default values are in place
    ihash.get( :c ).assert == 2
    # But the old defaults have been lost
    KeyError.assert.raised? do
      ihash.get :b
    end
```

### Defaults provided via a parameter

```ruby
    ihash = IHash.new a: 1

    ihash.get( :a ).assert == 1
    ihash.get( :a, 42 ).assert == 42

    # However values override the default of course
    ihash.set_values a: 2
    ihash.get( :a, 42 ).assert == 2
    
```


### Computed Defaults

They are the main reason for caching, but as defaults provided
via parameters override cached values, we will need an alternative
calculation mechanisme for business logic, which we will discuss
later on.

For know all we need to know to understand the following example
is that `Proc` instances as default values will be evaluated
in the `IHash` instance's context.

```ruby
    rectangle = IHash.new \
      height: ->{ get( :surface ) / get( :width ) },
      width: ->{ get( :surface ) / get( :height ) },
      surface: ->{ get( :width ) * get( :height ) }

    # Obviously we need some data here. The following code
    # will consume the whole stack before crashing.
    # Later on we will see how to avoid this by means
    # of defaults and constraints, and hopefully a later version
    # of IHash will detect the mutual infinite recursion.

    #   rectangle.get :surface

    # So let us provide some data
    rectangle.set_values width: 20, height: 30
    rectangle.get( :surface ).assert == 600
```

Now it would be nice if we could avoid the potential stack overflow
by means of defaults.
And, as promised, we can:

```ruby
    
    rectangle = IHash.new \
      height: ->{ get( :surface, 600 ) / get( :width, 20 ) },
      width: ->{ get( :surface, 600 ) / get( :height ) },
      surface: ->{ get( :width ) * get( :height ) }

    # These defaults shall be sufficent
    rectangle.get( :surface ).assert == 600
    # and they are.

```

To see how to do this with constraints, please refer to the [constraints demo](https://github.com/RobertDober/lab42_intellihash/blob/master/demo/050-constraints.md)
