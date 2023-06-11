defmodule EcholaliaTest.ArityWorksTest do
  use ExUnit.Case

  defmodule TestWithModuleFacade do
    use Echolalia,
      behaviour: EcholaliaTest.ArityWorks.Behaviour,
      impl: EcholaliaTest.ArityWorks.Implementation
  end

  defmodule TestWithFunctionFacade do
    use Echolalia,
      behaviour: EcholaliaTest.ArityWorks.Behaviour,
      impl: &__MODULE__.get_implementation/1

    # def get_implementation(args)

    def get_implementation([]), do: EcholaliaTest.ArityWorks.Implementation
    def get_implementation([_]), do: EcholaliaTest.ArityWorks.Implementation

    def get_implementation([_, _]),
      do: EcholaliaTest.ArityWorks.Implementation
  end

  defmodule TestWithCatchAllFacade do
    use Echolalia.CatchAll,
      behaviour: EcholaliaTest.ArityWorks.Behaviour,
      impl: &__MODULE__.catch_all/2

    IO.inspect(__MODULE__, label: "__MODULE__")

    def catch_all(function_name, args)

    def catch_all(:function_with_arity, args), do: length(args)
  end

  test "returns the correct arity when passing a module as implementation" do
    assert EcholaliaTest.ArityWorksTest.TestWithModuleFacade.function_with_arity() == 0
    assert EcholaliaTest.ArityWorksTest.TestWithModuleFacade.function_with_arity(1) == 1
    assert EcholaliaTest.ArityWorksTest.TestWithModuleFacade.function_with_arity(1, 2) == 2
  end

  test "returns the correct arity when passing a function to get the implementation" do
    assert EcholaliaTest.ArityWorksTest.TestWithFunctionFacade.function_with_arity() == 0
    assert EcholaliaTest.ArityWorksTest.TestWithFunctionFacade.function_with_arity(1) == 1
    assert EcholaliaTest.ArityWorksTest.TestWithFunctionFacade.function_with_arity(1, 2) == 2
  end

  test "returns the correct arity when passing a catch all function to get the implementation" do
    assert EcholaliaTest.ArityWorksTest.TestWithCatchAllFacade.function_with_arity() == 0
    assert EcholaliaTest.ArityWorksTest.TestWithCatchAllFacade.function_with_arity(1) == 1
    assert EcholaliaTest.ArityWorksTest.TestWithCatchAllFacade.function_with_arity(1, 2) == 2
  end
end
