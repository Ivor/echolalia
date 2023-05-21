defmodule EcholaliaTest.Arithmetic do
  defmodule AddBehaviour do
    @callback add(a :: number, b :: number) :: number
  end

  defmodule SubtractBehaviour do
    @callback subtract(a :: number, b :: number) :: number
  end

  defmodule MultiplyBehaviour do
    @callback multiply(a :: number, b :: number) :: number
  end

  defmodule AdderImpl do
    @behaviour EcholaliaTest.Arithmetic.AddBehaviour

    @impl true
    def add(a, b), do: a + b
  end

  defmodule SubtractorImpl do
    @behaviour EcholaliaTest.Arithmetic.SubtractBehaviour

    @impl true
    def subtract(a, b), do: a - b
  end

  defmodule MultiplierImpl do
    @behaviour EcholaliaTest.Arithmetic.MultiplyBehaviour

    @impl true
    def multiply(a, b), do: a * b
  end

  defmodule MultiplyFacade do
    use Echolalia,
      behaviour: EcholaliaTest.Arithmetic.MultiplyBehaviour,
      impl: &EcholaliaTest.Arithmetic.MultiplyFacade.implementation/1

    def implementation(_) do
      Application.get_env(:echolalia, :multiply_impl, EcholaliaTest.Aritmetic.MultiplierImpl)
    end
  end
end
