-- Reformat a client certificate's distinguished name from
-- OpenSSL 'slash separated format' into a comma separated format (RFC4514)
-- Author: James Milligan <james@milligan.tv>
-- 31/07/2017

-- Source: https://stackoverflow.com/a/7615129/1315130
-- splitString returns a table of elements from the input string
-- split on the provided separator
-- if the separator is not specified, whitespace is used
function splitString(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

-- Source: https://forums.coronalabs.com/topic/61784-function-for-reversing-table-order/?p=320168
function reverse(arr)
	local i, j = 1, #arr

	while i < j do
		arr[i], arr[j] = arr[j], arr[i]

		i = i + 1
		j = j - 1
	end
end

-- Fetch the DN using HAProxy's API, and use the above functions to format it
function rfc_client_dn(txn)
    local clientDnRaw = txn.f:ssl_c_s_dn()
    -- Split raw DN by forward slash into a table
    -- {"C=GB", "O=Example Corp"...}
    local clientDnSplit = splitString(clientDnRaw, "/")
    -- Reverse the order back into a standard X.509 format
    -- {"CN=John Smith (jsmith)", "OU=People"...}
    reverse(clientDnSplit)
    -- Format the DN in comma-separated format
    -- CN=John Smith (jsmith),OU=People...
    return table.concat(clientDnSplit, ",")
end

core.register_fetches("rfc_client_dn", rfc_client_dn)