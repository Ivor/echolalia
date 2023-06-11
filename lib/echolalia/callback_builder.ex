defmodule Echolalia.CallbackBuilder do
  defmacro build_callback(impl, behaviour, function_name, args \\ []) do
    quote bind_quoted: [
            impl: impl,
            behaviour: behaviour,
            function_name: function_name,
            args: args
          ] do
      @impl behaviour

      if is_function(impl) do
        # if the implementation is a function we first pass the args to that function to get the implementation
        # then call the function name on the implementation with the args.
        def unquote(function_name)(unquote_splicing(args)) do
          unquote(impl).(unquote(args))
          |> apply(unquote(function_name), unquote(args))
        end
      else
        # if the implementation is not a function we just call the function name on the implementation with the args
        def unquote(function_name)(unquote_splicing(args)) do
          unquote(impl)
          |> apply(unquote(function_name), unquote(args))
        end
      end
    end
  end
end
