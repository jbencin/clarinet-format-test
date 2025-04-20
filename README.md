# `clarinet format` test

This repo tests `clarinet format` by running it on all deployed contracts, and checking the output with `clarinet check`.
It uses `xargs` to run multiple threads, the default number is 8 but this can be changed by editing the file.

## Usage

Run the shell script, and you'll probably want to log the output to a file (there are lots of failure right now):

```bash
./run.sh &> run.log
```