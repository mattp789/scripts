foreach ($i in $args)
    {Get-Service -Name [service name] -ComputerName $i | stop-service; Get-Service -Name [service name] -ComputerName $i  }
