# ppparser

A Performance Port Parser that converts IP-port pairs to a JSON format.

# Concept

Read a text file with a list of IP addresses followed by individual lines of port numbers. Ignoring blank spaces and
comments (indicated by a `#`), generate a JSON file mapping the IP addresses to the corresponding ports.

# Usage

`dart bin/ppparser.dart -i <input-file> -o <output-file>`

Use `dart bin/ppparser.dart -h` for more usage.
