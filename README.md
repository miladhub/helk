# helk

This is a hello world project in Haskell. The project uses Scotty for REST, Aeson for JSON manipulation and MongoDB for persistence.

# Build

    stack build
    stack exec helk

# Run

## look at this README

    $ curl http://localhost:9176

## create a person

    $ curl http://localhost:9176/people -d '{ "name": "foo", "age": 42 }'
    {"age":42,"name":"foo"}

## look up a person by name

    $ curl http://localhost:9176/people/bar
    {"age":42,"name":"bar"}

## retrieve all people

    $ curl http://localhost:9176/people
    [{"age":42,"name":"foo"}]
