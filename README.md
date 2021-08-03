# RocksDB UI

A small web application that allows users to interact graphically with a RocksDB UI.
Uses the RocksDB client for Crystal from maiha: ([https://github.com/maiha/rocksdb.cr](https://github.com/maiha/rocksdb.cr))
More than a bit rough around the edges.

## Prerequisites

A working Crystal installation, version 0.36.1. See [here](https://crystal-lang.org/install/). 
Alternatively, you can install Crystal via [asdf](https://asdf-vm.com/) or on mac via HomeBrew (`brew install crystal@0.36.1`).

## Installation

1. Clone repo (`git clone https://github.com/Sander-V-D/rocksdb_ui.git`)
2. Run `shards install` in folder
3. (optional) Run `crystal build rocksdb_ui.cr --release --no-debug`.

## Usage

You can use the program via `crystal rocksdb_ui.cr ${/path/to/rocksdb/folder}`.
If you performed the optional step, you can alternatively use `./rocksdb_ui ${/path/to/rocksdb/folder}` (on macOS and Linux)

After that, visit [http://localhost:8080](http://localhost:8080) for the UI.

## Contributing

1. Fork it ( https://github.com/Sander-V-D/rocksdb_ui/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [Sander-V-D](https://github.com/Sander-V-D) - creator