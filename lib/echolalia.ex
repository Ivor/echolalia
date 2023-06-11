defmodule Echolalia.FunctionBuilder do
  defmacro define_function(impl, behaviour, function_name, args \\ []) do
    quote bind_quoted: [
            impl: impl,
            behaviour: behaviour,
            function_name: function_name,
            args: args
          ] do
      @impl behaviour

      if is_function(impl) do
        def unquote(function_name)(unquote_splicing(args)) do
          unquote(impl).(unquote(args))
          |> apply(unquote(function_name), unquote(args))
        end
      else
        def unquote(function_name)(unquote_splicing(args)) do
          unquote(impl)
          |> apply(unquote(function_name), unquote(args))
        end
      end
    end
  end
end

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

  ## Usage
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

  @doc false
  def get_callbacks(behaviour, filters)

  def get_callbacks(behaviour, %{only: only_list, except: nil}) when is_list(only_list) do
    behaviour.behaviour_info(:callbacks)
    |> Enum.filter(fn {function_name, _} -> function_name in only_list end)
  end

  def get_callbacks(behaviour, %{only: nil, except: except_list}) when is_list(except_list) do
    behaviour.behaviour_info(:callbacks)
    |> Enum.reject(fn {function_name, _} -> function_name in except_list end)
  end

  def get_callbacks(behaviour, %{only: nil, except: nil}) do
    behaviour.behaviour_info(:callbacks)
  end

  def get_callbacks(_, _),
    do: raise(ArgumentError, "You can't provide both :only and :except options")

  defmacro __using__(opts) do
    behaviour = Keyword.fetch!(opts, :behaviour)
    impl = Keyword.get(opts, :impl, nil)

    except = Keyword.get(opts, :except, nil)
    only = Keyword.get(opts, :only, nil)

    quote bind_quoted: [
            behaviour: behaviour,
            impl: impl,
            except: except,
            only: only
          ] do
      unless Enum.member?(Module.get_attribute(__MODULE__, :behaviour), behaviour) do
        @behaviour behaviour
      end

      require Echolalia.FunctionBuilder

      for {function_name, arity} <-
            Echolalia.get_callbacks(behaviour, %{except: except, only: only}) do
        if arity > 0 do
          args = for x <- 1..arity, do: {String.to_atom("arg#{x}"), [], Elixir}
          Echolalia.FunctionBuilder.define_function(impl, behaviour, function_name, args)
        else
          Echolalia.FunctionBuilder.define_function(impl, behaviour, function_name)
        end
      end
    end
  end
end
