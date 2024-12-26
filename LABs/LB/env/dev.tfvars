env = "dev"
location = "Central India"
subscription_id = "549e90a6-40ca-4c76-8aa8-8f6ea2a287f4"
rg_name = "sri"
vnet = {
    address_space = "10.0.0.0/8"
}
subnet = {
    SN1 = "10.0.2.0/24"
    SN2 = "10.0.3.0/24"
}
vm = {
    count = 1
    username = "azureadmin"
    password = "Cloud@20252025"
}
sa = {
    name = "csg10032001d012dbbf"
    rg_name = "cloud-shell-storage-centralindia"
}
