defmodule EcholaliaTest.ImplAsModuleTest do
  use ExUnit.Case

  defmodule Interface do
    use Echolalia,
      behaviour: EcholaliaTest.Arithmetic.AddBehaviour,
      impl: EcholaliaTest.Arithmetic.AdderImpl

    use Echolalia,
      behaviour: EcholaliaTest.Arithmetic.SubtractBehaviour,
      impl: EcholaliaTest.Arithmetic.SubtractorImpl
  end

  test "Interface implements the AddBehaviour behaviour" do
    assert Interface.add(1, 2) == 3
  end

  test "Interface implements the SubtractBehaviour behaviour" do
    assert Interface.subtract(2, 1) == 1
  end
end
