# Coding Challenge Testing
```
Usage: sh test.sh [-leh]
    -l
       Run the tests after each change in the root directory.
    -e
       Run extra tests.
    -h
       Print this help.
```

## Create Tests
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

## Test a Program
Inputs are sent to `run.sh`. Write the code to execute the program inside
`run.sh`.

## Sample Test Output
```
================================================================================
Checking test_case_1...
  Success!
Checking test_case_2...
  Failure!
    Expected:
      bar
    Actual:
      foo
    Diff:
      1c1
      < bar
      ---
      > foo
-----------------------------------------+--------------------------------------
                              ==###      | Test Cases: 2
  ##=                        #######     |    Success: 1
  ###=                     =###### #     |    Failure: 1
   #####====########======##### ####     |      Error: 0
    #####              ######    ###     +--------------------------------------
    ##        =             ##==###
    =#==###### #=##==         #####
   =########   ######====     ####
   ### # ###   #### #  ###==    ##
   ####=###==   ###===######     ##
  =###### #==#   ##########      ##
  ####   _=###=_    #######       #
   ###  #       #    #####        #
   ####=#        #   ####=         #
   ######=         #######         #
  =#############                   ##
  ###########====                   #=
  ##############                     #=
  ########==                          #
 =#######==                            #
 #############                         #
```

