package thx;

import utest.Assert;

class TestMake {
  public function new() {}

//  public function testConstructorLiteral() {
//    var f = Make.constructor((_: { c : String, b : Int, a : Float, d : String }));
//    Assert.same({
//      c : "A",
//      b : 1,
//      a : 0.2,
//      d : "D"
//    }, f("A", 1, 0.2, "D"));
//  }
//
//  public function testConstructorFromTypedef() {
//    var f = Make.constructor((_: ConstructorType));
//    Assert.same({
//      c : "A",
//      b : 1,
//      a : 0.2,
//      d : "D"
//    }, f("A", 1, 0.2, "D"));
//  }
//
  public function testPolyConstructorFromTypedef() {
    var f = Make.constructor((_: ConstructorPoly<Int>));
    Assert.same({ a: 1, b: 2 }, f(1, 2));
  }
}

@:sequence(c, b, a, d)
typedef ConstructorType = {
  c : String,
  b : Int,
  ?a : Float,
  d : String
}

typedef ConstructorPoly<A> = {
  a: A,
  b: A
}
