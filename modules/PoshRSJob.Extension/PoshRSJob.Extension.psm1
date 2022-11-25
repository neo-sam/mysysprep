function Get-RSJobOrWait {
    while (Get-RSJob) {
        if ($jobs = Get-RSJob -State Completed) { return $jobs[0] }
        if ($jobs = Get-RSJob -State Failed) { return $jobs[0] }
        Get-RSJob | Wait-RSJob -Timeout 1 | Out-Null
    }
}
