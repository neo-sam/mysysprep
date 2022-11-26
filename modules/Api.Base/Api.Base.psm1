function Get-Translation(
    [Parameter(Mandatory, ValueFromPipeline)]
    [string]$text,
    [string]$cn
) {
    switch ((Get-Culture).Name) {
        zh-CN { if ($cn) { return $cn } }
    }
    return $text
}
