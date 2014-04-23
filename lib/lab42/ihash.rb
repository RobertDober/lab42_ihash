module Lab42
  class IHash
    attr_reader :cache, :constraints, :defaults, :errors, :values

    def get key, *default
      values.fetch key do 
        lookup( key, *default )
      end
    end

    def set_constraints(**constraints)
      @constraints << constraints
      self
    end

    def set_defaults(**defaults)
      invalidate_cache_and_errors
      @defaults = defaults
      self
    end

    def set_values a_hashy={}
      invalidate_cache_and_errors
      
      @values = a_hashy.dup rescue a_hashy
      validate_constraints
      self
    end

    def valid?; errors.empty? end

    private
    def evaluate val_or_proc
      return evaluate_proc val_or_proc if Proc===val_or_proc
      val_or_proc
    end

    def evaluate_proc a_proc
      a_proc.arity == 1 ? instance_eval( &a_proc ) : instance_exec( &a_proc )
    end

    def initialize(**defaults)
      set_defaults(**defaults)

      @cache       = {}
      @values      = {}

      @constraints = []
      @errors      = []
    end

    def invalidate_cache_and_errors
      @cache  = {}
      @errors = []
    end

    # Precondition: key not in values and key not in cache
    # This explains the default value provided priority, we reason:
    # An explicit default value in a get shall override the predefined defaults
    # **But** that means that later caching will change the behavior of get not
    # my preferred programming style. This might change in the future. (E.g.
    # default comes before cache lookup).
    def lookup key, *default
      return default.first unless default.empty?
      cache.fetch key do
        raise KeyError, "#{key} not found in values, defaults or logic" unless defaults.has_key? key
        @cache[ key ] = evaluate( defaults[key] )
      end
    end

    def validate_constraints
      constraints.each do | constraint |
        values.each do | k, v |
          c = constraint[k]
          next unless c
          if c.arity == 1
            c.(v) || errors << "value error for key #{k.inspect} and value #{v.inspect}"
          else
            instance_exec(&c) || errors << "value error for key #{k.inspect} and value #{v.inspect}"
          end
        end
      end
    end
  end # class IHash
end # module Lab42
