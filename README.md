# ditg-mininet-controller-overhead



# Overview
This script compares the network overhead of various Software-Defined Networking (SDN) controllers. 

The workload generator used is the Mininet Flow Generator[^1]. This generates flows which test the controllers. Packets are measured using tshark and examined using Python's scapy library. This flow generator was modified to use D-ITG instead of iperf as the traffic generation mechanism.

We apply the Multiple Interleaved Trials (MIT) technique to obtain fair and repeatable comparisons in a virtualized environment. 

# How to run

```
./script.sh
```

# What it does

```
num_experiments = 15
for num_experiments
  for each controller
      starts controller
      clean mininet
      start the topology launcher
      launch tshark for packet capture
      kill the controller
      run statistical analysis on pcap file and store results in csv
  end for
end for
```
[^1]: https://github.com/stainleebakhla/mininet-flow-generator
