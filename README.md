# lab42_ihash

A Hash with Business Logic ( call it intelligent ).

Actually it is a view layer over a Hash like object, which needs to obey the simple protocol

`Hash#fetch`.


The services `IHash` provides are of the number of four:

* Default values per key.
* Validation via _Constraints_.
* Business Logic or Lookup Logic.
* Caching of Computed Values.


## Installation

```sh
    gem install lab42_ihash --pre
```

## Usage

```ruby
    require 'lab42/ihash'

    IHash = Lab42::IHash
```

Or to do the same in one line of code

```ruby
    require 'lab42/ihash/auto_import'
```



## Manual (QED Driven)

Details are explained in the [QED](https://github.com/rubyworks/qed) demos [here](https://github.com/RobertDober/lab42_intellihash/tree/master/demo)
