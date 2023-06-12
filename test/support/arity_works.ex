defmodule EcholaliaTest.ArityWorks do
  defmodule Behaviour do
    @callback function_with_arity(any()) :: integer()
    @callback function_with_arity(any(), any()) :: integer()
    @callback function_with_arity() :: integer()
  end

  defmodule Implementation do
    @behaviour EcholaliaTest.ArityWorks.Behaviour

    @impl EcholaliaTest.ArityWorks.Behaviour
    def function_with_arity(), do: 0

    @impl EcholaliaTest.ArityWorks.Behaviour
    def function_with_arity(_a) do
      1
    end

    @impl EcholaliaTest.ArityWorks.Behaviour
    def function_with_arity(_, _), do: 2
  end
end
