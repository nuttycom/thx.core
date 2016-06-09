package thx;

enum Equality {
  EQ;
  NEQ;
  Incomparable;
}

@:callable
abstract Eq<A> (A -> A -> Equality) from A -> A -> Equality to A -> A -> Equality {
  public function equal(a0: A, a1: A): Equality return this(a0, a1);

  public function contramap<B>(f: B -> A): Eq<B>
    return function(b0, b1) { return this(f(b0), f(b1)); }
}
