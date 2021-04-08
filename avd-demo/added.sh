# Using DC1-LEAF1A.yml as a yemplate

DHCP things 
'''
DHCP is the ip-dhcp-relay.j2 template within templates/
'''
#Added to DC1-LEAF1A.yaml
ip_dhcp_relay: 
  information_option: true

#To dos
{# eos - ip dhcp relay #}
{% if ip_dhcp_relay is defined and ip_dhcp_relay is not none %}
{%    if ip_dhcp_relay.information_option is defined and ip_dhcp_relay.information_option == true %}
!
ip dhcp relay information option
# Added the relay always-on
ip dhcp relay always-on
# Added the dhcp tunnel requests disabled 
dhcp relay 
  tunnel requests disabled
#snooping
ip dhcp snooping
{%    endif %}
{% endif %}

'''
DHCP is the ip-dhcp-relay.j2 template within templates/
'''

Need to add the DHCP sender config to vlan-interfaces.j2
This will require new structure changes with name of them plus vrf etc 
#   ip helper-address 192.168.2.5 vrf VRF_TIER3 source-interface Loopback3

# Added to data structure for DC1-LEAF1A.yml everything below dhcp_relay
Vlan110:
  tenant: Tenant_A
  tags: ['opzone']
  description: Tenant_A_OP_Zone_1
  vrf: Tenant_A_OP_Zone
  ip_address_virtual: 10.1.10.1/24
  dhcp:
    dhcp_relay: 192.168.2.5
    vrf: VRF_TIER3
    source_interface: Loopback3

# Changed template of vlan-interfaces.j2

{%         if vlan_interfaces[vlan_interface].dhcp is defined and vlan_interfaces[vlan_interface].dhcp is not none %}
   ip helper-address {{ vlan_interfaces[vlan_interface].dhcp.dhcp_relay }} vrf {{ vlan_interfaces[vlan_interface].dhcp.vrf }} source-interface {{ vlan_interfaces[vlan_interface].dhcp.source_interface }}
         {% endif %}

# OSPF

router_ospf:
  process_ids:
    1:
      bfd_enable: true
      max_lsa: 12000

## Current config 
'''
   network 10.0.0.0/8 area 0.0.0.0
   max-lsa 12000
   timers spf delay initial 0 200 200
   timers lsa rx min interval 100
   timers lsa tx delay initial 0 100 200
   max-metric router-lsa
'''

#Added to 

router_ospf:
  process_ids:
    1:
      bfd_enable: true
      max_lsa: 12000
      optimize: true #Adding all the timers and max-metrics 
      network: 10.0.0.0/8 area 0.0.0.0

#Added to the router-ospf.j2 This is probably cheating but oh well.
{%         if router_ospf.process_ids[process_id].optimize is defined %}
   timers spf delay initial 0 200 200
   timers lsa rx min interval 100
   timers lsa tx delay initial 0 100 200
   max-metric router-lsa
{%         endif %}

#Add to the ospf interfaces.

#Tcam profile only applicable to 7280R
tcam_profile: vxlan-routing
