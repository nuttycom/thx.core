package thx;

// Nothing is the uninhabited type. It has no constructors, 
// and signals nontermination or the bottom value.
enum Nothing {
}

class Nothings {
  /**
   * Since Nothing is uninhabited, the only thing that the returned function can do is
   * fail to terminate by throwing the provided exception.
   */
  public static function toNothing<A>(err: thx.Error): A -> Nothing {
    return function(a: A) throw err;
  }
}
