# haproxy-client-dn-format
A simple Lua module for HAProxy to fetch the subject name of a client-side certificate as an RFC4514-compliant string

Fetches the DN from the presented client certificate in the original OpenSSL-style, slash-separated format, reverses the order, and returns the DN in a comma separated format, e.g:

```
/C=GB/O=Example Corp/OU=People/CN=John Smith (jsmith)
```
becomes:
```
CN=John Smith (jsmith),OU=People,O=Example Corp,C=GB
```

## Usage
Within HAProxy (>=1.6), load the Lua script and use it where appropriate:

```
global
    lua-load rfc_client_dn.lua
frontend www
    http-request set-header "X-SSL-Client-DN" %{+Q}[lua.rfc_client_dn()]
```
