# Echolalia
`Echolalia` is a dynamic implementation generator for `Elixir` that streamlines the common pattern of having multiple implementations for a behaviour and a facade module that delegates to the appropriate implementation. This is particularly useful when you want to change the implementation at compile-time or runtime. Such a pattern can be useful for testing scenarios with mock frameworks like `Mox`, or when you have different implementations depending on varying parameters.

`Echolalia` helps reduce boilerplate code by automatically generating the necessary implementations based on the behaviour's callbacks. The implementation for each function can either be an atom that identifies a module or a function that will be called with the function arguments.

## Installation
Add `Echolalia` to your list of dependencies in mix.exs:

```elixir
def deps do
  [
    {:echolalia, "~> 0.1.0"}
  ]
end
```

## Usage
To use `Echolalia`, you use it inside a module, providing it with the `:behaviour` that you want to implement and the `:impl` that provides the implementation:

```elixir
defmodule MyModule do
  use Echolalia, behaviour: MyBehaviour, impl: MyImplementation
  use Echolalia, behaviour: MyOtherBehaviour, catch_all: MyModule.catch_all/2

  def catch_all(funtion_name, original_arguments) do
    ...
  end
end
```

`Echolalia` will then create functions for each of the callbacks in `MyBehaviour`, using the functions or module defined in `MyImplementation` for their implementation.

### Options
* `:behaviour` - The behaviour that you want to implement. This should be an atom that identifies a module with a behaviour definition.
* `:impl` - The implementation of the behaviour. This can either be a function or an atom that identifies a module. If it is a function, it will be called with the arguments for each function. If it is a module, the corresponding function in the module will be called.
* `:catch_all` - A function that will be called instead of trying to call a function on a behaviour. The function receives two arguments. The function name as an atom, and the the original arguments as a list. This is useful if you need to do some special handling like potentially execute the function in a separate task.

NOTE: You cannot specify both `:impl` and `:catch_all`.

## License
The Echolalia library is released under the [MIT License](https://opensource.org/licenses/MIT).

