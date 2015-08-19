-- Conky lib for dwm statusbar stuff with pango!

do
   local colours = {}
   colours["unknown"] = "#FF66FF" 
   local cpu_colours={}
   cpu_colours["low"] = "#00FF00"
   cpu_colours["medium"] = "#FF9900"
   cpu_colours["high"] = "#FF0000"

   local function makespan(text,fgcolour,bgcolour,style,attrs)
      -- right now ignores other params
      return string.format("<span color=\"%s\">%s</span>", fgcolour, text)
   end
   
   function conky_cpu_colourise(cpu)
      local _cpu = conky_parse(cpu)
      local _cpu_n = tonumber(_cpu)
      if (_cpu_n > 75.0) then
         return makespan(_cpu, cpu_colours.high,nil,nil,nil)
      elseif _cpu_n > 50.0 then
         return makespan(_cpu, cpu_colours.medium,nil,nil,nil)
      elseif _cpu_n > 25.0 then
         return makespan(_cpu, cpu_colours.low,nil,nil,nil)
      else
         return _cpu
      end
   end

   function conky_dwm_temp()
      local _sysctl_temp = io.popen("sysctl -n hw.acpi.thermal.tz0.temperature")
      local acpitemp = _sysctl_temp:read()
      _sysctl_temp:close()
      _sysctl_temp = io.popen("sysctl -n hw.acpi.thermal.tz0._CRT")
      local crit_temp = _sysctl_temp:read()
      _sysctl_temp:close()
      local temp = string.gsub(acpitemp, "C", "")
      temp = tonumber(temp)
      crit_temp =string.gsub(crit_temp,"C", "")
      crit_temp = tonumber(crit_temp)
      acpitemp = string.gsub(acpitemp, "C", "\194\176C")
      if temp >= crit_temp then
         return makespan(acpitemp,"#FF0000",nil,nil,nil)
      elseif temp >= 80 then
         return makespan(acpitemp,"#FF3300",nil,nil,nil)
      elseif temp >= 50 then
         return makespan(acpitemp,"#FF9900",nil,nil,nil)
      else
         return makespan(acpitemp,"#00FF00",nil,nil,nil)
      end
   end
end
