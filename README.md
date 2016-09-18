# Coding Challenge Testing
## Usage
```
Usage: sh test.sh [-lseh]
    -l
       Run the tests after each change in the root directory.
    -e
       Run extra tests.
    -s
       Remove memes.
    -h
       Print this help.
```

## Setup
### Create tests
Add tests in `test` directory:
```
mkdir test
mkdir test/input
mkdir test/output
```
Files in the `input` directory represent inputs for one test case
and files with same name in the `output` directory represent expected results:
```
echo "input1" > test/input/test_case_1
echo "expectation1" > test/output/test_case_1
```
The same applies to extra tests. Put extra tests in `extra_test`
directory instead of `test` directory.

### Test a program
Inputs are sent to `run.sh`. Write the code to execute the program inside
`run.sh`.
