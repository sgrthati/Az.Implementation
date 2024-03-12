# Point to Site VPN Setup

## we have to provision Azure Network Gateway

## after creating VPN GW,we have to authorize VPN GW with Azure AD by below link and we to accept there

[admin consent to share Azure VPN](https://login.microsoftonline.com/common/oauth2/authorize?client_id=41b23e61-6c1e-4545-b367-cd054e0ed4b4&response_type=code&redirect_uri=https://portal.azure.com&nonce=1234&prompt=admin_consent)

![image](https://github.com/sgrthati/Az.Implementation/assets/101870480/c83db2d9-3407-41c1-b76d-b46f37383345)

## we have to create a connection in Point to site

![image](https://github.com/sgrthati/Az.Implementation/assets/101870480/629584cc-689d-4f0d-a14c-f0e27c9c8ae6)

## below are the Details we have to replace TenantId with Actual Tenant ID

![image](https://github.com/sgrthati/Az.Implementation/assets/101870480/1f39719c-52dd-4f04-a585-7c98517c809e)

## after refreshing at Point to site,we were able to download VPN Client,download it and move it to machine,where we want to make a connection to Our network

## download AzureVPN Client and import config in that system

## login with Azure AD Credentials

