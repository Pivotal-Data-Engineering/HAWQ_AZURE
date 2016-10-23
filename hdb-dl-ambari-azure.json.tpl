{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json",
  "contentVersion": "1.0.0.0",
   "resources": [
    {
      "type": "Microsoft.Storage/storageAccounts",
      "name": "{{ resourceGroupName~'storage' }}",
      "apiVersion": "{{ resourceAPIVersion }}",
      "location": "[resourceGroup().location]",
      "properties": {
        "accountType": "{{ storageAccountType }}"
      }
    },
		{% for i in range(ambariVMCount) %}
    {
      "type": "Microsoft.Network/publicIPAddresses",
      "name": "{{ resourceGroupName~'publicip'~i }}",
      "apiVersion": "{{ resourceAPIVersion }}",
      "location": "[ resourceGroup().location ]",
      "properties": {
        "publicIPAllocationMethod": "Dynamic",
        "dnsSettings": {
          "domainNameLabel": "{{ resourceGroupName~i }}"
        }
      }
    },
		{% endfor %}
    {
      "type": "Microsoft.Network/virtualNetworks",
      "name": "{{ resourceGroupName~'net' }}",
      "apiVersion": "{{ resourceAPIVersion }}",
      "location": "[resourceGroup().location]",
      "properties": {
        "addressSpace": {
          "addressPrefixes": [
            "10.0.0.0/16"
          ]
        },
        "subnets": [
          {
            "name": "{{ resourceGroupName~'subnet' }}",
            "properties": {
              "addressPrefix": "10.0.0.0/24"
            }
          }
        ]
      }
    },
		{% for i in range(ambariVMCount) %}
    {
      "type": "Microsoft.Network/networkInterfaces",
      "name": "{{ resourceGroupName~'nic'~i }}",
      "apiVersion": "{{ resourceAPIVersion }}",
      "location": "[resourceGroup().location]",
      "dependsOn": [
        "Microsoft.Network/publicIPAddresses/{{resourceGroupName~'publicip'~i }}",
        "Microsoft.Network/virtualNetworks/{{ resourceGroupName~'net' }}"
      ],
      "properties": {
        "ipConfigurations": [
          {
            "name": "{{ resourceGroupName~'nic'~i~'ip1' }}",
            "properties": {
              "privateIPAllocationMethod": "Dynamic",
              "publicIPAddress": {
                "id": "[resourceId('Microsoft.Network/publicIPAddresses', '{{ resourceGroupName~'publicip'~i }}') ]"
              },
              "subnet": {
                "id": "[concat(resourceId('Microsoft.Network/virtualNetworks', '{{ resourceGroupName~'net' }}'),'/subnets/{{ resourceGroupName~'subnet' }}')]"
              }
            }
          }
        ]
      }
    },
		{% endfor %}
		{% for i in range(ambariVMCount) %}
    {
      "type": "Microsoft.Compute/virtualMachines",
      "name": "{{ resourceGroupName~'vm'~i }}",
      "apiVersion": "{{ resourceAPIVersion }}",
      "location": "[resourceGroup().location]",
      "dependsOn": [
        "Microsoft.Network/networkInterfaces/{{ resourceGroupName~'nic'~i }}",
        "Microsoft.Storage/storageAccounts/{{ resourceGroupName~'storage' }}"
      ],
      "properties": {
        "hardwareProfile": {
          "vmSize": "{{ ambariVMSize }}"
        },
        "osProfile": {
          "computerName": "{{ resourceGroupName~'ambari'~i }}",
          "adminUsername": "{{ adminUsername }}",
          "linuxConfiguration": {
            "disablePasswordAuthentication": "true",
            "ssh": {
              "publicKeys": [
                {
                  "path": "/home/{{ adminUsername }}/.ssh/authorized_keys",
                  "keyData": "{{ adminPublicKey }}"
                }
              ]
            }
          }
        },
        "storageProfile": {
          "imageReference": {
            "publisher": "OpenLogic",
            "offer": "CentOS",
            "sku": "6.7",
            "version": "latest"
          },
          "osDisk": {
            "name": "{{ resourceGroupName~'ambari'~i~'osdisk' }}",
            "vhd": {
						"uri": "http://{{ resourceGroupName~'storage' }}.blob.core.windows.net/{{ resourceGroupName~'ambari'~i }}/osdisk.vhd"
            },
            "caching": "ReadWrite",
            "createOption": "FromImage"
          },
          "dataDisks": [
            {
              "name": "{{ resourceGroupName~'ambari'~i~'datadisk' }}",
              "diskSizeGB": {{ segmentDataDiskSize }},
              "lun": 0,
              "vhd": {
								"uri": "http://{{ resourceGroupName~'storage' }}.blob.core.windows.net/{{ resourceGroupName~'ambari'~i }}/datadisk.vhd"
              },
              "caching": "None",
              "createOption": "Empty"
            }           
          ]
        },
        "networkProfile": {
          "networkInterfaces": [
            {
              "id": "[resourceId('Microsoft.Network/networkInterfaces', '{{ resourceGroupName~'nic'~i }}') ]"
            }
          ]
        }
      }
    } {% if not loop.last %},{% endif %}
	{% endfor %}
 ],
  "outputs": {
    
  }
}
