# Dryer Services
A gem providing base classes for composable service object that leverages the
[dry-monads](https://dry-rb.org/gems/dry-monads/1.6/) gem for error handling.

## Installation
add the following to you gemfile
```
gem "dryer_services"
```

## Usage
This gem provides two base classes, `SimpleService` and `ResultService`.

Both classes provide a single class method `call`, and require the inheriting class to
define the instance methods `initialize` and `call`

`SimpleService` is meant to be used for operations that have no failure modes,
while `ResultsService` is meant to be used for operations that may fail.

### SimpleService Example

```
class Add < Dryer::Services::SimpleService
    def initialize(a, b)
        @a = a
        @b = b
    end

    def call
        a + b
    end

    private
    attr_reader :a, :b
end

Add.call(1,2) # returns 3
```

### ResultService Example

Result Service wraps the value returned from `call` in a `Dry::Monad::Result`.
If the return value is an Error, it will return a Failure. If the return value
is already a `Dry::Monad::Result`, it will not wrap the result, otherwise it
will wrap the result in a `Dry::Monads::Success`

```
class Divide < Dryer::Services::ResultService
    def initialize(a, b)
        @a = a
        @b = b
    end

    def call
        if b == 0
            StandError.new("Can not divide by zero")
        else
            a/b
        end
    end

    private
    attr_reader :a, :b
end

Add.call(4,2) # returns Dry::Monads::Success(2)
Add.call(4,0) # returns Dry::Monads::Failure("Can not divide by zero")
```

## Advantages
Using the Service pattern can help to make code more modular, and make it easier
to separate data modeling from transformations.

# Development
This gem is set up to be developed using [Nix](https://nixos.org/)
Once you have nix installed you can run
`make env`
to enter the development environment. Then run `make` to see other available
commands

If you don't want to use nix, all the scripts can be run directly from the
`scripts` directory.

## Contributing
Please create a github issue to report any problems using the Gem.
Thanks for your help in making testing easier for everyone!

## Versioning
Dryer Services follows Semantic Versioning 2.0 as defined at https://semver.org.

## License
This code is free to use under the terms of the MIT license.
