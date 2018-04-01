# helk

This is a hello world project in Haskell.

# Build

    stack build
    stack exec helk

# Run

    curl -X POST http://localhost:9176 -d '{ "name": "foo", "age": 42 }'

The answer should be something like this:

    {"age":42,"name":"foo"}

