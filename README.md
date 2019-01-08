# fluent-plugin-filter-vaultaudit

### Overview
A filter plugin for [Fluentd](http://www.fluentd.org/) that allows you to display **known** plain text values on [Vault](https://www.vaultproject.io/) audit logs.

### Configuration
The following parameters are supported:

##### keywords (Required)

Here you can specify one or more known keywords (if more than 1, separate them by `,`) in plain text, the plugin will calculate call Vault API to get the hash of each.

##### vaultaddr (Required)
To specify the Vault address where the request to get the hashes will be sent. 


##### vaulttoken (Required)
The token to authenticate the call that calculates the hashes. 

##### vaultcert
For SSL communication, you can specify here the path of a CA certificate file to be used when calling the API. It defaults to: `/fluentd/etc/certs/cert.crt`

##### vaultauditpath
The path where the audit device was enabled within vault. It defaults to: `socket`

```
<source>
  @type  tcp
  <parse>
    @type json
  </parse>
  tag tcp.events
  port  24224
</source>

<filter tcp.events>
  @type vault_decode
  keywords 11112222333444555, S3cRe7
  vaultaddr https://vaultendpoint:8200
  vaulttoken AAAABBBBBcccDDDDeeeFFFF
</filter>

<filter tcp.events>
  @type stdout
</filter>
```
