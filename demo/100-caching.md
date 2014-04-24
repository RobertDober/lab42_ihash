# IHash QED

## Caching

Will only occur when lookup values or default values are accessed.

Actually `#cache` is exposed as an attribute, but manipulate it not (or at your
own risk).

```ruby
    ihash = IHash.new \
      a: ->{ 42 }, 
      b: 42

    # The cache is empty
    ihash.cache.assert.empty?

    # Let us access :b
    ihash.get :b
    # The cache is not empty any more
    ihash.cache.refute.empty?
    # It has been filled with :b only
    ihash.cache.assert.has_key? :b
    ihash.cache.refute.has_key? :a
    # And now we add :a
    ihash.get :a
    ihash.cache.assert.has_key? :b
    ihash.cache.assert.has_key? :a
    
```

### Setting values invalidates the cache

```ruby
    ihash.set_values b: 56

    # Cache is empty again
    ihash.cache.assert.empty?
    # Values come before the cache, but don't do that
    ihash.cache[ :b ] = 22
    ihash.get( :b ).assert == 56
    # We did not even break anything
    ihash.get( :a ).assert == 42
    ihash.cache.assert.has_key? :a

```

### Value access does not populate the cache

```ruby
    ihash.set_values b: 29

    ihash.cache.assert.empty?
    ihash.get( :b ).assert == 29
    ihash.cache.assert.empty?
```


### Setting defaults invalidates the cache too

```ruby
    ihash.get :a
    ihash.cache.keys.assert == [:a]
    ihash.set_defaults
    # The following is not very wise, maybe setting values, defaults
    # or constraints will reset the instance.
    # Not sure: ihash.get( :b ).assert == 29
    ihash.cache.assert.empty?

```


This behavior might change with minor version updates as it is not very
intuitive.

Now that we are aware how caching and default values work let us go further with constraints

