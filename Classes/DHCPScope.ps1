class DHCPScope {
    [string] $Name
    [ipaddress] $StartRange
    [ipaddress] $EndRange
    [ipaddress] $SubnetMask
    [ipaddress] $ScopeID
    [ipaddress] $DnsServer

    DHCPScope(
        [string] $Name,
        [ipaddress] $StartRange,
        [ipaddress] $EndRange,
        [ipaddress] $SubnetMask,
        [ipaddress] $ScopeID,
        [ipaddress] $DnsServer
    ) {
        $this.Name = $Name
        $this.StartRange = $StartRange
        $this.EndRange = $EndRange
        $this.SubnetMask = $SubnetMask
        $this.ScopeID = $ScopeID
        $this.DnsServer = $DnsServer
    }
}