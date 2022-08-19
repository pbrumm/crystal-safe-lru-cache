require "mt_helpers"
require "lru-cache"

class SafeLRUCache(K, V)
  include Synchronizable

  def initialize(*, max_size : Int32? = nil)
    @inner = LRUCache(K, V).new(max_size: max_size)
    @synchronize_lock = Mutex.new(:reentrant)
  end

  macro method_missing(call)
    synchronize do
      @inner.{{call}}
    end
  end

  def clear
    synchronize do
      @inner.clear
      self
    end
  end
end
