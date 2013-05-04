-- Extension description
function descriptor()
 return { title = "Simulwatch" ;
  version = "1.0" ;
  author = "Vishnu & Dhruv" ;
  url = 'https://github.com/pathsny/vlc_simulwatch';
  shortdesc = "simulwatch";
  description = "simulwatch" ;
  capabilities = { "input-listener" }
 }
end

fd = nil
prevStatus = 'unknown'

function send_tcp_request(body)
  vlc.net.send(fd, body)
  -- vlc.net.close(fd)
end

function on_http_request(data, url, request, type_a, in_a, addr, host)
  vlc.osd.message(data)
end

function intf_handler(var, old, new, data)
  -- vlc.msg.dbg("intf_handler invoked.");
  -- send_tcp_request("text:Nothing to report here. Over & Out.")
  local currStatus = vlc.playlist.status()
  
  if (currStatus ~= prevStatus) then
    if (currStatus == 'playing') then
	  send_tcp_request("playing:")
	elseif (currStatus == 'paused') then
	  send_tcp_request("paused:")
	end
	prevStatus = currStatus
  end

  local data = vlc.net.recv(fd, 100)
  if (data == nil) then
    return
  end
    
  vlc.msg.dbg("DATA:" .. data)
  local channel = vlc.osd.channel_register()
  if (channel == nil) then
    return
  end
  
  offset = string.find(data, "text:")
  if (offset == 1) then
    local toShow = string.sub(data, 6)
    vlc.osd.channel_clear(channel)
    vlc.osd.message(toShow, channel, 'bottom', 2000000)
  else
    offset = string.find(data, "paused:")
    if (offset == 1) then
      if (prevStatus ~= 'paused') then
	    vlc.playlist.pause()
	  end
    else
	  offset = string.find(data, "playing:")
      if (offset == 1) then
	    vlc.playlist.pause()
      end
    end
  end
end

function activate()
   vlc.msg.dbg("[remember pos] Welcome")
   local dlg = vlc.dialog("Streaming Radio Player")
   -- local button_play = dlg:add_button("Play", click_play, 1, 4, 4, 1)
   dlg:show()
   local input = vlc.object.input()

   -- Use correct hostname here
   fd = vlc.net.connect_tcp( "172.19.23.42", 1378 )
   vlc.net.send(fd, "nick:birdman")

   -- for k,v in pairs(vlc.input) do vlc.msg.dbg("KEY: " .. k) end
   -- local httpd = vlc.httpd( "0.0.0.0", 1377 )
   -- httpd:handler("/data", nil, nil, nil, on_http_request, '')

   local input = vlc.object.input()
   vlc.var.add_callback(input, "intf-event", intf_handler, "Hello world!")

   -- vlc.msg.dbg(vlc.osd.register_channel());
   -- local data = "dhruv"
   -- vlc.osd.message(data, vlc.osd.register_channel(), "bottom", 2000);
end

function deactivate()
  vlc.msg.dbg("[remember pos] deact")
  local input = vlc.object.input()
  vlc.var.del_callback(input, "intf-event", intf_handler, "Hello world!")
end

