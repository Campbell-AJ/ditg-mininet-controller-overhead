#!/bin/bash
for (( n=0; n<15; n++ ))
do

    cd ~/pox
    sudo ./pox.py forwarding.l2_learning host_tracker openflow.discovery openflow.of_01 --port=6633 &
    echo "********** POX CONTROLLER STARTED **********"

    cd ~/mininet-flow-generator
    sudo mn --clean &> /dev/null
    echo "********** CLEANUP COMPLETE **********"
    echo "********** STARTING TRAFFIC **********"
    sudo expect -c '
        spawn sudo python launch4.py --controller=remote,ip=127.0.0.1 --topo=linear,5
        exec sudo tshark -i "any" -f "tcp port 6633" -a duration:100 -w pox.pcap &
        interact
    '

    sleep 2
    echo "********** TSHARK FINISHED **********"

    sudo pkill -9 -f pox*
    echo "********** POX CONTROLLER KILLED **********"

    sudo echo "Run $n" >> pox.csv
    sudo python stat.py pox.pcap >> pox.csv
    echo "********** POX CONTROLLER RESULTS SAVED TO FILE **********"



    cd ~/mininet-flow-generator
    sudo mn --clean &> /dev/nul
    echo "********** CLEANUP COMPLETE **********"
    echo "********** STARTING TRAFFIC **********"
    sudo expect -c '
        spawn sudo python launch4.py --controller=ovsc,ip=127.0.0.1 --topo=linear,5
        exec sudo tshark -i "any" -f "tcp port 6633" -a duration:100 -w ovsc.pcap &
        interact
    '

    sleep 2
    echo "********** TSHARK FINISHED **********"

    sudo echo "Run $n" >> ovsc.csv
    sudo python stat.py ovsc.pcap >> ovsc.csv &
    echo "********** OVS CONTROLLER RESULTS SAVED TO FILE **********"

    cd ~/mininet-flow-generator
    sudo mn --clean &> /dev/null
    echo "********** CLEANUP COMPLETE **********"
    echo "********** STARTING TRAFFIC **********"
    sudo expect -c '
        spawn sudo python launch4.py --topo=linear,5
        exec sudo tshark -i "any" -f "tcp port 6653" -a duration:100 -w default.pcap &
        interact
    '
    sleep 2
    echo "********** TSHARK FINISHED **********"

    sudo echo "Run $n" >> default.csv
    sudo python stat.py default.pcap >> default.csv &
    echo "********** DEFAULT CONTROLLER RESULTS SAVED TO FILE **********"

    sudo mn --clean &> /dev/null
done
