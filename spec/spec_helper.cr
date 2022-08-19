require "spec"
require "../src/crystal_safe_lru_cache"

alias Cache = SafeLRUCache(Symbol, String)
alias LifecycleCache = LifecycleLRUCache(Symbol, String)

# LRU cache with hooks.
class LifecycleLRUCache(K, V) < SafeLRUCache(K, V)
  getter count_after_set : Int32 = 0
  getter count_after_delete : Int32 = 0
  getter count_after_clear : Int32 = 0

  # Lifecycle method to be executed after setting an item (`add!` and `set`).
  private def after_set(key : K, item : Tuple(V, Time?))
    @count_after_set += 1
  end

  # Lifecycle method to be executed after deleting an item (`delete`, expiration).
  private def after_delete(key : K, item : Tuple(V, Time?)?)
    @count_after_delete += 1
  end

  # Lifecycle method to be executed after clearing all the cache (`clear`).
  private def after_clear
    @count_after_clear += 1
  end
end
