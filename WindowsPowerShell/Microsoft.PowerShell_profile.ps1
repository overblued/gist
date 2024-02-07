function netshinterfaceportproxy { netsh interface portproxy @Args }
Set-Alias -Name nip  -Value netshinterfaceportproxy

function mklinkasln { New-Item -ItemType SymbolicLink -Path $args[1] -Target $args[0] }
Set-Alias -Name ln  -Value mklinkasln

function netshinterfaceportproxyadd { 
     $a1, $p1 = $args[0].Split(':') 
     $a2, $p2 = $args[1].Split(':')
    netsh interface portproxy add v4tov4 listenaddress=$a1 listenport=$p1 connectaddress=$a2 connectport=$p2
}
Set-Alias -Name nipa -Value netshinterfaceportproxyadd

function netshinterfaceportproxydelete { 
     $a1, $p1 = $args[0].Split(':') 
    netsh interface portproxy delete v4tov4 listenaddress=$a1 listenport=$p1
}
Set-Alias -Name nipd -Value netshinterfaceportproxydelete
