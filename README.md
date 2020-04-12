# helk

This is a hello world project in Haskell. The project uses Scotty for REST, Aeson for JSON manipulation and MongoDB for persistence.

# Prerequisites

  Helk uses (MongoDB)[https://docs.mongodb.com/manual/administration/install-community/] to store people information.

# Building

    stack build

# Running

    mongod --config /usr/local/etc/mongod.conf
    stack exec helk-exe

## Viewing this README

    $ curl http://localhost:9176

## Creating a person

    curl http://localhost:9176/people -d '{ "name": "foo", "age": 42 }'
    {"age":42,"name":"foo"}

    curl http://localhost:9176/people -d '{ "name": "bar", "age": 100 }'
    {"age":100,"name":"bar"}

## Looking up by name

    curl http://localhost:9176/people/foo
    {"age":42,"name":"foo"}

## Retrieving all people

    curl http://localhost:9176/people
    [{"age":42,"name":"foo"},{"age":100,"name":"bar"}]

## Deleting people

    curl -X DELETE http://localhost:9176/people/foo
    curl -X DELETE http://localhost:9176/people/bar
    curl http://localhost:9176/people
    []

