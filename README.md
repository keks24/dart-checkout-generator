# Introduction
`dart-checkout-generator` generates every possible checkout combination for `double out` and `master out` games.

# Prerequisites
The following packages are installed:
```no-highlight
bash
```

# Installation
Clone the repository into your current working directory:
```bash
$ git clone "https://gitlab.com/keks24/dart-checkout-generator.git"
```

# Usage
Execute the bash script:
```bash
$ cd "dart-checkout-generator/"
$ ./dart_checkout_generator.sh --double-out
```

```bash
$ ./dart_checkout_generator.sh --help
```
```no-highlight
Usage: ./dart_checkout_generator.sh <options>

OPTIONS:
  --double-out                  Calculate all possible combinations for a double checkout game.
  --master-out                  Calculate all possible combinations for a master checkout game.
  --help                        Print this help.
  --version                     Print the version and exit.
```

# Known issues
Currently there are still duplicate outputs. A generated list has to be filtered afterwards:
```bash
$ ./dart_checkout_generator --double-out > double_checkouts
$ sort --reverse --numeric-sort --key="3" double_checkouts | uniq > double_checkouts_filtered
```
