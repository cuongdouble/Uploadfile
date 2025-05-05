# Move mouse and click at middle right screen position
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class MouseSimulator {
    [DllImport("user32.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
    public static extern void mouse_event(uint dwFlags, uint dx, uint dy, uint cButtons, uint dwExtraInfo);
}
"@

function Click-AtPosition {
    param (
        [int]$x,
        [int]$y
    )

    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
    Start-Sleep -Milliseconds 100

    # 0x02 = left down, 0x04 = left up
    [MouseSimulator]::mouse_event(0x02, 0, 0, 0, 0)
    Start-Sleep -Milliseconds 50
    [MouseSimulator]::mouse_event(0x04, 0, 0, 0, 0)
}

# Get screen size
Add-Type -AssemblyName System.Windows.Forms
$screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height

# Calculate middle right position
$x = $screenWidth - 10  # 10 pixel lệch vào bên trong phải
$y = [math]::Round($screenHeight / 2)

Click-AtPosition -x $x -y $y

Write-Host "✅ Clicked at ($x, $y)"
