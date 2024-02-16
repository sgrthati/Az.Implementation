# LOGIN AZURE VM'S WITH AZURE AD

#Create a VM by enabling Azure AD
![image](https://github.com/sgrthati/Az.Implementation/assets/101870480/89ed055f-dd80-426a-90d3-3caeec230e9c)

#in provisioned VM, by installing "Azure AD based Windows Login"

![image](https://github.com/sgrthati/Az.Implementation/assets/101870480/a4db3f1e-3d32-4190-920a-7e10b85a4b25)

#Provision state should be "Provisioning Succeeded"

![image](https://github.com/sgrthati/Az.Implementation/assets/101870480/d14c819d-2ca8-434d-9c57-dcf4e04e3093)

#we have to give below roles to AD based login to the VM

VM > Access Control > Add Role Assignment > choose below roles based on requirement > choose members > Review+assign

  ![image](https://github.com/sgrthati/Az.Implementation/assets/101870480/c1f469ef-b371-43fd-a8e5-b3861812728f)

# We have to Disable NLA,after that we have to Restart VM

![image](https://github.com/sgrthati/Az.Implementation/assets/101870480/6339e46d-50bc-47f7-bb09-8132e33df1fd)

#we have to download RDP file for VM,and we have to add last 2 highlighted lines to RDP File,it will be look like this
```note
full address:s:"PUBLIC-IP":3389
prompt for credentials:i:1
administrative session:i:1
enablecredsspsupport:i:0
authentication level:i:2
```
#we have to RDP,with role assigned user

![image](https://github.com/sgrthati/Az.Implementation/assets/101870480/e3ea8c52-d6c6-4ff4-be5c-3cd8cd9c1880)

