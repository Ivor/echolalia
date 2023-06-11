defmodule Echolalia.CatchAll do
  @moduledoc """
  The `Echolalia.CatchAll` module is a variant of the `Echolalia` module that provides a "catch-all" implementation for a behaviour. This means that instead of providing a specific implementation for each function of the behaviour, a single function is provided that will be used for all functions of the behaviour.

  This can be particularly useful in cases where the implementation of the behaviour's functions is similar or identical, or when you want to provide a default implementation that can be overridden.

  ## Usage
  To use `Echolalia.CatchAll`, you just need to `use` it inside a module, providing it with the `:behaviour` that you want to implement and the `:impl` that provides the catch-all implementation:

  ```elixir
  defmodule MyModule do
    use Echolalia.CatchAll, behaviour: MyBehaviour, impl: &my_catch_all/2

    def my_catch_all(function_name, args) do
      # ...
    end
  end
  ```

  `Echolalia.CatchAll` will then create functions for each of the callbacks in MyBehaviour, using the provided catch-all function for their implementation.

  ## Options
  * :behaviour - The behaviour that you want to implement. This should be an atom that identifies a module with a behaviour definition.
  * :impl - The catch-all implementation of the behaviour. This should be a function that takes two arguments: the name of the function being called and a list of its arguments.

  """
  defmacro __using__(opts) do
    behaviour = Keyword.fetch!(opts, :behaviour)
    catch_all_fn = Keyword.fetch!(opts, :impl)

    except = Keyword.get(opts, :except, nil)
    only = Keyword.get(opts, :only, nil)

    quote bind_quoted: [
            behaviour: behaviour,
            catch_all_fn: catch_all_fn,
            except: except,
            only: only
          ] do
      unless Enum.member?(Module.get_attribute(__MODULE__, :behaviour), behaviour) do
        @behaviour behaviour
      end

      for {function_name, arity} <-
            Echolalia.get_callbacks(behaviour, %{except: except, only: only}) do
        if arity > 0 do
          args = for x <- 1..arity, do: {String.to_atom("arg#{x}"), [], Elixir}

          @impl behaviour
          def unquote(function_name)(unquote_splicing(args)) do
            unquote(catch_all_fn).(unquote(function_name), unquote(args))
          end
        else
          @impl behaviour
          def unquote(function_name)() do
            unquote(catch_all_fn).(unquote(function_name), [])
          end
        end
      end
    end
  end
end
