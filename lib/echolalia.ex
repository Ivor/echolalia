defmodule Echolalia do
  @moduledoc """
  The `Echolalia` module is a dynamic implementation generator that addresses a common pattern
  in Elixir where multiple implementations for a behaviour exist and a facade module calls the
  functions on the specific implementation. This allows the user to set the implementation at
  compile-time or at runtime. This pattern is particularly useful for testing with mocks (like
  the Mox library) or when having different implementations depending on varying parameters.

  `Echolalia` minimizes the boilerplate associated with this pattern by dynamically generating
  the necessary implementation based on the behaviour's callbacks. The implementation of each
  function can either be an atom that identifies a module or a function that will be called
  with the function arguments.

  ## How to use
  To use `Echolalia`, you just need to `use` it inside a module, providing it with the
  `:behaviour` that you want to implement and the `:impl` that provides the implementation:

  ```elixir
  defmodule MyModule do
    use Echolalia, behaviour: MyBehaviour, impl: MyImplementation
  end
  ```

  `Echolalia` will then create functions for each of the callbacks in `MyBehaviour`,
  using the functions or module defined in `MyImplementation` for their implementation.

  ## Options
  * :behaviour - The behaviour that you want to implement. This should be an atom that
  identifies a module with a behaviour definition.
  * :impl - The implementation of the behaviour. This can either be a function or an atom
  that identifies a module. If it is a function, it will be called with the arguments for
  each function. If it is a module, the corresponding function in the module will be called.
  """

  defmacro __using__(opts) do
    behaviour = Keyword.fetch!(opts, :behaviour)
    impl = Keyword.fetch!(opts, :impl)

    quote bind_quoted: [behaviour: behaviour, impl: impl] do
      @behaviour behaviour

      callbacks = behaviour.behaviour_info(:callbacks)

      for {function_name, arity} <- callbacks do
        args = for x <- 1..arity, do: {String.to_atom("arg#{x}"), [], Elixir}

        if is_function(impl) do
          @impl behaviour
          def unquote(function_name)(unquote_splicing(args)) do
            unquote(impl).(unquote(args))
            |> apply(unquote(function_name), unquote(args))
          end
        else
          @impl behaviour
          def unquote(function_name)(unquote_splicing(args)) do
            unquote(impl)
            |> apply(unquote(function_name), unquote(args))
          end
        end
      end
    end
  end
end
