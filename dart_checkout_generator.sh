#!/bin/bash
#############################################################################
# Copyright 2019 Ramon Fischer                                              #
#                                                                           #
# Licensed under the Apache License, Version 2.0 (the "License");           #
# you may not use this file except in compliance with the License.          #
# You may obtain a copy of the License at                                   #
#                                                                           #
#     http://www.apache.org/licenses/LICENSE-2.0                            #
#                                                                           #
# Unless required by applicable law or agreed to in writing, software       #
# distributed under the License is distributed on an "AS IS" BASIS,         #
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  #
# See the License for the specific language governing permissions and       #
# limitations under the License.                                            #
#############################################################################

# define global variables
declare -ai single_score_array=(0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 25)
declare -ai double_score_array=(0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 50)
declare -ai triple_score_array=(0 3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48 51 54 57 60)
declare -ai double_checkout_score_array=(2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 50)
declare -ai triple_checkout_score_array=(3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48 51 54 57 60)
declare -i max_checkout_score_double_out="170"
declare -i max_checkout_score_master_out="180"
## combine all score combinations for the first two darts
declare -ai first_dart_score_array=("${single_score_array[@]}" "${double_score_array[@]}" "${triple_score_array[@]}")
declare -ai second_dart_score_array=("${single_score_array[@]}" "${double_score_array[@]}" "${triple_score_array[@]}")

# refactor me: this function brute forces all combinations; it would be more efficient to use a decent formula.
#              also there are duplicate outputs
# calculate all combinations for a double checkout with three darts
calculateCheckout()
{
    local checkout_game="${1}"

    case "${checkout_game}" in
        "double_out")
            local max_checkout_score="${max_checkout_score_double_out}"
            local checkout_dart_score_array=("${double_checkout_score_array[@]}")
            ;;

        "master_out")
            local max_checkout_score="${max_checkout_score_master_out}"
            local checkout_dart_score_array=("${double_checkout_score_array[@]}" "${triple_checkout_score_array[@]}")
            ;;

        "master_out_only")
            local max_checkout_score="${max_checkout_score_master_out}"
            local checkout_dart_score_array=("${triple_checkout_score_array[@]}")
            ;;

        *)
            echo -e "\e[01;31mSomething went wrong while choosing the checkout game.\e[0m"
            exit 1
    esac

    for checkout_score in $(eval /bin/echo {${max_checkout_score}..${double_score_array[0]}})
    do
        for checkout_dart_score in "${checkout_dart_score_array[@]}"
        do
            for second_dart_score in "${second_dart_score_array[@]}"
            do
                for first_dart_score in "${first_dart_score_array[@]}"
                do
                    local total_score="$(( first_dart_score + second_dart_score + checkout_dart_score ))"

                    if [[ "$(( total_score - checkout_score ))" == "0" ]]
                    then
                        /bin/echo -e "checkout score: ${checkout_score}\t|\t1st dart: ${first_dart_score}\t|\t2nd dart: ${second_dart_score}\t|\tcheckout dart: ${checkout_dart_score}"
                    fi
                done
            done
        done
    done
}

getUsage()
{
    case "${1}" in
        "error")
            exit_code="1"
            ;;

        "ok")
            exit_code="0"
            ;;

        *)
            exit_code="1"
    esac

    /bin/echo ""
    /bin/echo "Usage: ${0} <options>"
    /bin/echo ""
    /bin/echo "OPTIONS:"
    /bin/echo "  --double-out                   Calculate all possible combinations for a double checkout game."
    /bin/echo "  --master-out                   Calculate all possible combinations for a master checkout game."
    /bin/echo "  --master-out-only              Calculate all possible combinations for a master checkout game but consider triple outs only."
    /bin/echo "  --help                         Print this help."
    /bin/echo "  --version                      Print the version and exit."
    exit "${exit_code}"
}

getVersion()
{
    /bin/echo '       __           __           __              __               __                                        __                  __  '
    /bin/echo '  ____/ /___ ______/ /_    _____/ /_  ___  _____/ /______  __  __/ /_     ____ ____  ____  ___  _________ _/ /_____  __________/ /_ '
    /bin/echo ' / __  / __ `/ ___/ __/   / ___/ __ \/ _ \/ ___/ //_/ __ \/ / / / __/    / __ `/ _ \/ __ \/ _ \/ ___/ __ `/ __/ __ \/ ___/ ___/ __ \'
    /bin/echo '/ /_/ / /_/ / /  / /_    / /__/ / / /  __/ /__/ ,< / /_/ / /_/ / /_     / /_/ /  __/ / / /  __/ /  / /_/ / /_/ /_/ / /  (__  ) / / /'
    /bin/echo '\__,_/\__,_/_/   \__/____\___/_/ /_/\___/\___/_/|_|\____/\__,_/\__/_____\__, /\___/_/ /_/\___/_/   \__,_/\__/\____/_(_)/____/_/ /_/ '
    /bin/echo '                   /_____/                                       /_____/____/                                                       '
    /bin/echo ""
    /bin/echo "Version 0.3.0"
    exit 0
}

main()
{
    if [[ "${1}" == "" ]]
    then
        getUsage "error"
    fi

    while (( ${#} ))
    do
        case "${1}" in
            "--double-out")
                calculateCheckout double_out
                ;;

            "--help")
                getUsage "ok"
                ;;

            "--master-out")
                calculateCheckout master_out
                ;;

            "--master-out-only")
                calculateCheckout master_out_only
                ;;

            "--version")
                getVersion
                ;;

            *)
                echo -e "\e[01;31mThe parameter '${1}' does not exist.\e[0m"
                getUsage "error"
        esac

        shift 1 || break
    done
}

main "${@}"
