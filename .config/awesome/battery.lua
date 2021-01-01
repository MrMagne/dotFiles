local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")
local watch = require("awful.widget.watch")

-- acpi sample outputs
-- Battery 0: Discharging, 75%, 01:51:38 remaining
-- Battery 0: Charging, 53%, 00:57:43 until charged

local path_to_icons = "/usr/share/icons/Arc/status/symbolic/"

battery_widget = wibox.widget { 
    {
        id = "icon",
        widget = wibox.widget.imagebox, 
        resize = false
    },
    layout = wibox.container.margin(brightness_icon, 0, 0, 3),
    set_image = function(self, path)
        self.icon.image = path
    end
}

watch(
    "acpi", 10,
    function(widget, stdout, stderr, exitreason, exitcode)
        local batteryType
        local _, status, charge_str, time = string.match(stdout, '(.+): (%a+), (%d?%d%d)%%,? ?.*')
        local charge = tonumber(charge_str)
        if (charge >= 0 and charge < 15) then 
            batteryType="battery-empty%s-symbolic"
            show_battery_warning()
        elseif (charge >= 15 and charge < 40) then batteryType="battery-caution%s-symbolic"
        elseif (charge >= 40 and charge < 60) then batteryType="battery-low%s-symbolic"
        elseif (charge >= 60 and charge < 80) then batteryType="battery-good%s-symbolic"
        elseif (charge >= 80 and charge <= 100) then batteryType="battery-full%s-symbolic"
        end
        if status == 'Charging' then 
            batteryType = string.format(batteryType,'-charging')
        else
            batteryType = string.format(batteryType,'')
        end
        battery_widget.image = path_to_icons .. batteryType .. ".svg"
    end
)

function show_battery_status()
    awful.spawn.easy_async([[bash -c 'acpi']],
        function(stdout, stderr, reason, exit_code)   
            naughty.notify{
                text = stdout,
                title = "Battery status",
                timeout = 5, hover_timeout = 0.5,
                width = 200,
            }
        end
    )
end

function show_battery_warning()
    naughty.notify{
    --icon = "/home/pashik/.config/awesome/nichosi.png",
    icon = path_to_icons .. "dialog-warning-symbolic.svg",
    icon_size=100,
    text = "Huston, we have a problem",
    title = "Battery is dying",
    timeout = 5, hover_timeout = 0.5,
    position = "bottom_right",
    bg = "#F06060",
    fg = "#EEE9EF",
    width = 300,
}
end

-- popup with battery info
battery_widget.widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () show_battery_status() end)
))
