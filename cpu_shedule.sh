#!/bin/bash
# Author : Rishabh Raj
# Script follows here:

RoundRobin()
{
    total=0
    counter=0
    wait_time=0
    turnaround_time=0
    echo
    echo "Enter the Number of Process:";
    read limit
    x=$limit;
    arrival_time=( $(seq $limit) )
    burst_time=( $(seq $limit) )
    temp=( $(seq $limit) )
    echo "Enter Details of Process";
    echo "Enter Arrival Time:"
    read -a arrival_time
    echo "Enter Burst Time:"
    read -a burst_time
    for ((j=0;i<$limit;i++))
        do
            temp[$i]=${burst_time[$i]};
        done    
    echo "Enter Time Quantum:"
    read time_quantum
    printf "\n%-30s | %-30s | %-30s | %-30s" "Scheduling Order" "Burst Time" "Turnaround Time" "Waiting Time"
    for ((total=0,i=0;x!=0;))
        do
            if [ ${temp[$i]} -le $time_quantum ] && [ ${temp[$i]} -gt 0 ]
                then
                    total=$(expr $total + ${temp[$i]})
                    temp[$i]=0
                    counter=1
            elif [ ${temp[$i]} -gt 0 ]
                then
                    temp[$i]=$(expr ${temp[$i]} - $time_quantum)
                    total=$(expr $total + $time_quantum)
            fi
            if [ ${temp[$i]} -eq 0 ] && [ $counter -eq 1 ]
                then
                    ((x=x-1))
                    printf "\n%-30s | %-30s | %-30s | %-30s" "P$(expr ${i} + 1)" "${burst_time[i]}" "$(expr ${total} - ${arrival_time[$i]})" "$(expr ${total} - ${arrival_time[$i]} - ${burst_time[$i]})"
                    wait_time=$(expr $wait_time + $total - ${arrival_time[$i]} - ${burst_time[$i]})
                    turnaround_time=$(expr $turnaround_time + $total - ${arrival_time[$i]})
                    counter=0;
            fi
            if [ $i -eq $(expr $limit - 1) ]
                then
                    i=0
            elif [ ${arrival_time[$(expr $i + 1)]} -le $total ]
                then
                    i=$(expr $i + 1)
            else
                  i=0;

            fi
        done
    average_wait_time=$(($wait_time / $limit))
    average_turnaround_time=$(($turnaround_time / $limit))
    printf "\nAverage Waiting Time: $average_wait_time nanseconds"
    printf "\nAverage Turnaround Time: $average_turnaround_time nanseconds"
}

 

 

#shortest job first
ShortestJobFirst()
{
    echo
    echo "Enter the Number of Process:";
    read num_processes
    total=0
    procy=( $(seq $num_processes) )
    wt=( $(seq $num_processes) )
    echo "Enter the CPU burst time for $num_processes process in nano seconds with spaces"
    read -a bt
    for ((i=0;i<$num_processes;i++))
        do
            pos=$i
            for ((j=$(expr $i + 1);j<$num_processes;j++))
                do  
                    if ((${bt[j]} < ${bt[pos]}))
                    then
                        pos=$j
                    fi
                done
            temp=${bt[$i]};
            bt[$i]=${bt[$pos]};
            bt[$pos]=$temp;
            temp=${procy[$i]};
            procy[$i]=${procy[$pos]};
            procy[$pos]=$temp;
        done
    wt[0]=0;
    for ((i=1;i<$num_processes;i++))
    do
        wt[$i]=0
            for ((j=0;j<$i;j++))
            do
                wt[$i]=$(expr ${wt[$i]} + ${bt[$j]})
            done
        total=$(expr $total + ${wt[$i]})
    done

    avg_wt=$(($total / $num_processes))
    echo "Scheduling order:             ${procy[*]}"
    echo "Start time for each process:  ${bt[*]}"
    echo "Average Waiting Time: $total/$num_processes = $avg_wt nanoseconds"
    echo 
}


# Main Code
function menu {
	clear
	echo
	echo -e "\t\tAlgorithm: \n"
	echo -e "\t1. Shortest Job First"
	echo -e "\t2. Round Robin Algorithm"
	echo -e "\t3. Exit"
	echo -en "\t\tEnter an Option: "
	read -n 1 option
}

while [ 1 ]
do
	menu
	case $option in
	1)
	ShortestJobFirst ;;

	2)
	RoundRobin ;;

	3)
	break ;;

	*)
	echo "Sorry, wrong selection";;
	esac
	echo -en "\n\n\t\t\tHit any key to continue"
	read -n 1 line
done
