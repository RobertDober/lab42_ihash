lab42_intellihash
=================

A Hash with Business Logic ( call it intelligent ).

Actually it is a view layer over a Hash like object, which needs to obey the simple protocol

`Hash#fetch` and, optionally in case constraints want to be used, `Hash#each`. 

## Usage

```ruby
    require 'lab42/ihash'

    IHash = Lab42::IHash
    IntelliHash = Lab42::IntelliHash
```


## Manual (QED Driven)

Details are explained in the QED demos [here](https://github.com/RobertDober/lab42_intellihash/tree/master/demo)
