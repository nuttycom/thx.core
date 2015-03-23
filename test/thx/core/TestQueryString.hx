package thx.core;

import utest.Assert;
using thx.core.QueryString;

class TestQueryString {
  public function new() { }

  public function testBasics() {
    Assert.same(
      { foo : "bar" },
      QueryString.parse("?foo=bar").object()
    );

    Assert.same(
      { foo : "bar" },
      QueryString.parse("#foo=bar").object()
    );

    Assert.same(
      { foo : "bar" },
      QueryString.parse("foo=bar").object()
    );

    Assert.same(
      { foo : null },
      QueryString.parse("foo").object()
    );

    Assert.equals(
      "foo",
      QueryString.parse("foo").toString()
    );

    Assert.same(
      { foo : null, key : null },
      QueryString.parse("foo&key").object()
    );

    Assert.same(
      { foo : "bar", key : null },
      QueryString.parse("foo=bar&key").object()
    );

    Assert.same(
      {  },
      QueryString.parse("?").object()
    );

    Assert.same(
      {  },
      QueryString.parse("#").object()
    );

    Assert.same(
      {  },
      QueryString.parse(" ").object()
    );

    Assert.same(
      { foo : ["bar", "baz"] },
      QueryString.parse("foo=bar&foo=baz").object()
    );

    Assert.same(
      { "foo faz" : "bar baz  " },
      QueryString.parse("foo+faz=bar+baz++").object()
    );

    Assert.equals(
      "foo=bar",
      ({foo: 'bar'} : QueryString).toString()
    );

    Assert.equals(
      "foo=bar&bar=baz",
      ({foo: 'bar', bar: 'baz'} : QueryString).toString()
    );

    Assert.equals(
      "foo%20bar=baz%20faz",
      ({'foo bar': 'baz faz'} : QueryString).toString()
    );

    Assert.equals(
      "abc=abc&foo=bar&foo=baz",
      ({abc: 'abc', foo: ['bar', 'baz']} : QueryString).toString()
    );

    Assert.equals(
      "a=b&c=d",
      ("a=b&c=d" : QueryString).toString()
    );
  }
}