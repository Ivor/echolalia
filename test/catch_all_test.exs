defmodule EcholaliaTest.CatchAllTest do
  use ExUnit.Case

  test "catch all works" do
    assert EcholaliaTest.CaseByCase.upcase("hello", []) == "HELLO"
    assert EcholaliaTest.CaseByCase.downcase("HELLO", []) == "hello"
  end

  test "catch all and execute concurrently" do
    assert EcholaliaTest.CaseByCase.upcase("hello", concurrent: true) == "HELLO"
    assert EcholaliaTest.CaseByCase.downcase("HELLO", concurrent: true) == "hello"
    assert EcholaliaTest.CaseByCase.random_case("hello", concurrent: true) in ["hello", "HELLO"]
  end
end
