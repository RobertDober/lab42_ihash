module Lab42
  class IHash
    attr_reader :cache, :defaults, :values

    def get key
      values.fetch key do 
        cache.fetch key do
          lookup key
        end
      end
    end

    def set_defaults(**defaults)
      @defaults = defaults
      self
    end

    def set_values a_hashy
      @values = a_hashy.dup rescue a_hashy
      self
    end

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
      @cache  = {}
      @values = {}
    end

    def lookup key
      raise KeyError, "#{key} not found in values, defaults or logic" unless defaults.has_key? key
      @cache[ key ] = evaluate( defaults[key] )
    end
  end # class IHash
end # module Lab42
