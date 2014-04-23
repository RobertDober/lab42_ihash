# IHash QED

## Defaults

The first itch `lab42_intellihash` scratches is to provide defaults for (e.g. parameters from the
CL or a `yaml` file or who knows a webservice request returning `json`).

```ruby
    default_value =
      IHash
        .new( a: 42 )
        .set_values( b: 42 )
        .get( :a )

    default_value.assert == 42
```

## Business Logic

Is implemented by means of defaults too, we will just provide lambdas, which will be evaluated
in the context of the `IHash` instance. We are using the explicit invocation of set_defaults
here (which is called by  `initialize` if appropriate).

```ruby
    ihash = IHash.new
    ihash.set_defaults \
      a: 6,
      b: ->{ get( :a ).succ },
      c: ->{ get( :a ) * get( :b ) }

    # Note the absence of values here
    ihash.get( :c ).assert == 42
```


