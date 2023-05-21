defmodule EcholaliaTets.MoxTest do
  use ExUnit.Case

  import Mox

  setup :verify_on_exit!

  test "stub works" do
    EcholaliaTest.Arithmetic.MultiplyMock
    |> stub(:multiply, fn _, _ -> 5 end)

    assert EcholaliaTest.Arithmetic.MultiplyFacade.multiply(2, 2) == 5
    assert EcholaliaTest.Arithmetic.MultiplyFacade.multiply(1, 2) == 5
    assert EcholaliaTest.Arithmetic.MultiplyFacade.multiply(2, 3) == 5
  end

  test "expect works" do
    EcholaliaTest.Arithmetic.MultiplyMock
    |> expect(:multiply, 2, fn
      5, 6 -> 7
      2, 2 -> 5
    end)

    assert EcholaliaTest.Arithmetic.MultiplyFacade.multiply(2, 2) == 5
    assert EcholaliaTest.Arithmetic.MultiplyFacade.multiply(5, 6) == 7
  end
end
