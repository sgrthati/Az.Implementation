env = "dev"
location = "Central India"
subscription_id = "549e90a6-40ca-4c76-8aa8-8f6ea2a287f4"
rg_name = "sri"
vnet = {
    CLOUD = {
        address_space = "10.0.0.0/8"
        subnet = "10.0.0.0/24"
    }
    ONPREM = {
        address_space = "192.168.0.0/16"
        subnet = "192.168.0.0/24"
    }
}
vm = {
    count = 1
    username = "azureadmin"
    password = "Cloud@20252025"
}