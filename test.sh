#!/usr/bin/env bash

# parse options ################################################################
loop=false
check_extra=false
serious=false
while getopts ":lseh" opt
do
  case $opt in
    l)
      loop=true
      ;;
    s)
     serious=true
      ;;
    e)
     check_extra=true
      ;;
    h)
      echo "Usage: sh $0 [-lseh]"
      echo "    -l"
      echo "       Run the tests after each change in the root directory."
      echo "    -e"
      echo "       Run extra tests."
      echo "    -s"
      echo "       Remove memes."
      echo "    -h"
      echo "       Print this help."
      exit
      ;;
    \?)
      echo "Invalid option: -${OPTARG}"
      sh $0 -h
      exit
      ;;
  esac
done

# setup tests ##################################################################
root_dir=$(dirname $0)
test_dir=${root_dir}/test
if [ ${check_extra} = true ]
then
  test_dir=${root_dir}/extra_test
fi
input_dir=${test_dir}/input
output_dir=${test_dir}/output
tmp_dir=`mktemp -d`

exit_status=0

success_color="\x01$(tput setaf 2)\x02"
failure_color="\x01$(tput setaf 3)\x02"
error_color="\x01$(tput setaf 1)\x02"
result_color="\x01$(tput setaf 2)\x02"
color_end="\x01$(tput sgr0)\x02"

# run tests (will be executed once unless '-l' option as been set) #############
loop_next=true
sum_md5=""
md5_command="md5sum"
# on Mac OS X, use md5 instead of md5sum
hash ${md5_command} 2> /dev/null || { md5_command="md5"; }
while ${loop_next}
do
  # if '-l' options is set, the test run only if the md5 of the root directory
  # is the same as the md5 of the root directory before the current loop
  new_sum_md5="must not be the same as sum_md5 to always run tests once"
  if [ ${loop} = true ]
  then
    # this could slow up things
    # hey! code challenges are just small pieces of code ;)
    new_sum_md5=`tar -cf - ${root_dir} 2> /dev/null | ${md5_command}`
  fi
  if [ "${sum_md5}" != "${new_sum_md5}" ]
  then
    # TESTS ####################################################################
    echo "================================================================================"
    test_count=0
    success_count=0
    failure_count=0
    error_count=0
    exit_status=0
    if [ -d ${input_dir} ]
    then
      inputs=`ls ${input_dir}`
      for test_case in ${inputs}
      do
        input=${input_dir}/${test_case}
        expected=${output_dir}/${test_case}
        if [ -f ${expected} ]
        then
          actual=${tmp_dir}/${test_case}.res
          error=${tmp_dir}/${test_case}.err
          expected_vs_actual=${tmp_dir}/${test_case}.diff
          # run the program to test
          echo "Checking ${test_case}..."
          sh ${root_dir}/run.sh ${input} > ${actual} 2> ${error}

          # evaluate the result
          if [ $? -eq 0 ]
          then
            diff ${expected} ${actual} > ${expected_vs_actual}
            if [ "`cat ${expected_vs_actual}`" != "" ]
            then
              echo "  ${failure_color}Failure!${color_end}"
              echo "    ${failure_color}Expected:${color_end}"
              cat ${expected} | sed -e "s/^/      /g"
              echo "    ${failure_color}Actual:${color_end}"
              cat ${actual} | sed -e "s/^/      /g"
              echo "    ${failure_color}Diff:${color_end}"
              cat ${expected_vs_actual} | sed -e "s/^/      /g"
              failure_count=$(expr ${failure_count} + 1)
              exit_status=1
            else
              echo "  ${success_color}Success!${color_end}"
              success_count=$(expr ${success_count} + 1)
            fi
          else
            echo "  ${error_color}ERROR!${color_end}"
            cat ${error} | sed -e "s/^/    /g"
            error_count=$(expr ${error_count} + 1)
            exit_status=1
          fi
          test_count=$(expr ${test_count} + 1)
        fi
      done
    fi

    # summarize tests ##########################################################
    if [ ${failure_count} -gt 0 ]
    then
      if [ ${error_count} -eq 0 ]
      then
        result_color=${failure_color}
      else
        result_color=${error_color}
      fi
    else
      if [ ${error_count} -gt 0 ]
      then
        result_color=${error_color}
      fi
    fi
    if [ ${serious} = true ]
    then
      echo "--------------------------------------------------------------------------------"
      echo "${result_color}Test Cases: ${test_count}${color_end}"
      echo "   ${success_color}Success: ${success_count}${color_end}"
      echo "   ${failure_color}Failure: ${failure_count}${color_end}"
      echo "     ${error_color}Error: ${error_count}${color_end}"
    else
      echo "-----------------------------------------+--------------------------------------"
      echo "${result_color}                              ==###${color_end}      | ${result_color}Test Cases: ${test_count}${color_end}"
      echo "${result_color}  ##=                        #######${color_end}     |    ${success_color}Success: ${success_count}${color_end}"
      echo "${result_color}  ###=                     =###### #${color_end}     |    ${failure_color}Failure: ${failure_count}${color_end}"
      echo "${result_color}   #####====########======##### ####${color_end}     |      ${error_color}Error: ${error_count}${color_end}"
      echo "${result_color}    #####              ######    ###${color_end}     +--------------------------------------"
      echo "${result_color}    ##        =             ##==###${color_end}"
      echo "${result_color}    =#==###### #=##==         #####${color_end}"
      echo "${result_color}   =########   ######====     ####${color_end}"
      echo "${result_color}   ### # ###   #### #  ###==    ##${color_end}"
      echo "${result_color}   ####=###==   ###===######     ##${color_end}"
      echo "${result_color}  =###### #==#   ##########      ##${color_end}"
      echo "${result_color}  ####   _=###=_    #######       #${color_end}"
      echo "${result_color}   ###  #       #    #####        #${color_end}"
      echo "${result_color}   ####=#        #   ####=         #${color_end}"
      echo "${result_color}   ######=         #######         #${color_end}"
      echo "${result_color}  =#############                   ##${color_end}"
      echo "${result_color}  ###########====                   #=${color_end}"
      echo "${result_color}  ##############                     #=${color_end}"
      echo "${result_color}  ########==                          #${color_end}"
      echo "${result_color} =#######==                            #${color_end}"
      echo "${result_color} #############                         #${color_end}"
    fi
    ############################################################################
    if [ ${loop} = true ]
    then
      sleep 3s
      sum_md5=${new_sum_md5}
    fi
  fi
  loop_next=${loop}
done

rm -rf ${tmp_dir}

exit ${exit_status}

