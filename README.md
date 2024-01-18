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

### ResultService Examples

ResultService wraps the value returned from `call` in a `Dry::Monad::Result`.
There are several cases
    - If the return value is an Error, it will return a Failure
    - If the return value is not an Error, and is not a Result, it will wrap the
      return value in a Result
    - If the return value is a list of Results eg [Success(1), Success(2)] it
      will condense those results into a single Result eg Success([1,2]). If any
      of the results in the list are Failures eg [Success(1), Failure(2)], It
      will return the first failure encountered eg Failure(2). Changing a list
      of Monads (Results) into a Monad containing a list of values, is called
      'traversing'
   - If the return value is already a `Dry::Monad::Result`, it will not wrap the
     result

#### Wrapping an error in a Failure
```
class Divide < Dryer::Services::ResultService
    def initialize(a, b)
        @a = a
        @b = b
    end

    def call
        if b == 0
            StandardError.new("Can not divide by zero")
        else
            a/b
        end
    end

    private
    attr_reader :a, :b
end

Divide.call(4,2) # returns Dry::Monads::Success(2)
Divide.call(4,0) # returns Dry::Monads::Failure("Can not divide by zero")
```

#### Traversing a list of results
```
class DivideMany < Dryer::Services::ResultService
    def initialize(a, b)
        @a = a
        @b = b
    end

    def call
        # each call to Divide returns a Result
        # so we are returning a list of Results
        a.map { |x| Divide.call(x,b) }
    end

    private
    attr_reader :a, :b
end

DivideMany.call([2,4,6],2) # returns Dry::Monads::Success([1,2,3])
DivideMany.call([2,4,6],0) # returns Dry::Monads::Failure("Can not divide by zero")
```

## Advantages
Using the Service pattern can help to make code more modular, and make it easier
to separate data modeling from transformations.

## Development
This gem is set up to be developed using [Nix](https://nixos.org/) and
[ruby_gem_dev_shell](https://github.com/jbernie2/ruby_gem_dev_shell)
Once you have nix installed you can run `make env` to enter the development
environment and then `make` to see the list of available commands

## Contributing
Please create a github issue to report any problems using the Gem.
Thanks for your help in making testing easier for everyone!

## Versioning
Dryer Services follows Semantic Versioning 2.0 as defined at https://semver.org.

## License
This code is free to use under the terms of the MIT license.
