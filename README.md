### AVD todos
### General syslog/vlans etc

### Render EVPN tests 

### This is a small test environment using [containerlab](https://github.com/srl-labs/containerlab/blob/master/README.md)

To deploy make sure to install cEOS with the following.

```shell
docker import coesimage:4.25.1F ceos-lab.tar.tar
```

Where ceos-lab.tar.tar is the version that is downloaded from the [software downloads page.](https://eos.arista.com/tag/software-downloads/)

### Start the lab

```shell
containerlab deploy --topo lab.yml
```

<details><summary> Reveal output</summary>
<p>

```javascript
INFO[0000] Parsing & checking topology file: lab.yml    
INFO[0000] Creating lab directory: /home/burnyd/projects/containerlab-labs/clab-lab 
INFO[0000] Creating docker network: Name='clab', IPv4Subnet='172.20.20.0/24', IPv6Subnet='2001:172:20:20::/80', MTU='1500' 
INFO[0000] Creating container: leaf1                    
INFO[0000] Creating container: spine2                   
INFO[0000] Creating container: leaf2                    
INFO[0000] Creating container: spine1                   
INFO[0000] Creating container: leaf3                    
INFO[0000] Creating container: leaf4                    
INFO[0008] Restarting 'spine2' node                     
INFO[0008] Restarting 'leaf1' node                      
INFO[0008] Restarting 'leaf2' node                      
INFO[0008] Restarting 'leaf3' node                      
INFO[0008] Restarting 'leaf4' node                      
INFO[0008] Restarting 'spine1' node                     
INFO[0016] Creating virtual wire: spine2:eth2 <--> leaf2:eth2 
INFO[0016] Creating virtual wire: spine2:eth3 <--> leaf3:eth2 
INFO[0016] Creating virtual wire: spine2:eth4 <--> leaf4:eth2 
INFO[0016] Creating virtual wire: spine2:eth1 <--> leaf1:eth2 
INFO[0016] Creating virtual wire: leaf3:eth3 <--> leaf4:eth3 
INFO[0016] Creating virtual wire: spine1:eth1 <--> leaf1:eth1 
INFO[0016] Creating virtual wire: leaf1:eth3 <--> leaf2:eth3 
INFO[0016] Creating virtual wire: spine1:eth2 <--> leaf2:eth1 
INFO[0016] Creating virtual wire: spine1:eth4 <--> leaf4:eth1 
INFO[0016] Creating virtual wire: spine1:eth3 <--> leaf3:eth1 
INFO[0017] Writing /etc/hosts file                      
+---+-----------------+--------------+-------------------+------+-------+---------+----------------+----------------------+
| # |      Name       | Container ID |       Image       | Kind | Group |  State  |  IPv4 Address  |     IPv6 Address     |
+---+-----------------+--------------+-------------------+------+-------+---------+----------------+----------------------+
| 1 | clab-lab-leaf1  | 81080863968b | coesimage:4.25.1F | ceos |       | running | 172.20.20.4/24 | 2001:172:20:20::6/80 |
| 2 | clab-lab-leaf2  | dc56b2ae0e72 | coesimage:4.25.1F | ceos |       | running | 172.20.20.5/24 | 2001:172:20:20::7/80 |
| 3 | clab-lab-leaf3  | c2cebb2c2fc6 | coesimage:4.25.1F | ceos |       | running | 172.20.20.6/24 | 2001:172:20:20::5/80 |
| 4 | clab-lab-leaf4  | b117acbdd418 | coesimage:4.25.1F | ceos |       | running | 172.20.20.7/24 | 2001:172:20:20::4/80 |
| 5 | clab-lab-spine1 | 675fa64d9202 | coesimage:4.25.1F | ceos |       | running | 172.20.20.2/24 | 2001:172:20:20::2/80 |
| 6 | clab-lab-spine2 | 8c4d9557317f | coesimage:4.25.1F | ceos |       | running | 172.20.20.3/24 | 2001:172:20:20::3/80 |
+---+-----------------+--------------+-------------------+------+-------+---------+----------------+----------------------+
```
</p>
</details>

To use the ansible-playbook to deploy ansible / EVPN across the devices once deployed.

```shell
ansible-playbook -i clab-lab/ansible-inventory.yml playbook.yml --tags evpn
```

<details><summary> Reveal output</summary>
<p>

```javascript
PLAY [all] ***********************************************************************************************************************

TASK [Add evpn config with evpn tag] *********************************************************************************************
changed: [clab-lab-spine1]
changed: [clab-lab-leaf2]
changed: [clab-lab-leaf1]
changed: [clab-lab-leaf4]
changed: [clab-lab-leaf3]
changed: [clab-lab-spine2]

PLAY RECAP ***********************************************************************************************************************
clab-lab-leaf1             : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
clab-lab-leaf2             : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
clab-lab-leaf3             : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
clab-lab-leaf4             : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
clab-lab-spine1            : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
clab-lab-spine2            : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
</p>
</details>

docker exec -it clab-lab-leaf1 Cli

<details><summary> Reveal output</summary>
<p>

```javascript
leaf1#show bgp evpn summary 
BGP summary information for VRF default
Router identifier 1.1.1.1, local AS number 65001
Neighbor Status Codes: m - Under maintenance
  Neighbor         V  AS           MsgRcvd   MsgSent  InQ OutQ  Up/Down State   PfxRcd PfxAcc
  8.8.8.8          4 6500               4         6    0    0 00:00:57 Estab   0      0
  9.9.9.9          4 6500               3         6    0    0 00:00:52 Estab   0      0

```
</p>
</details>

### To destroy the environment


containerlab destroy --topo lab.yml --cleanup