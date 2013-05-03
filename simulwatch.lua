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

function activate()
   vlc.msg.dbg("[remember pos] Welcome")
   local dlg = vlc.dialog("Streaming Radio Player")
   local button_play = dlg:add_button("Play", click_play, 1, 4, 4, 1)
   dlg:show()
   local input = vlc.object.input()
   vlc.var.add_callback(input, "intf-event", input_event_handler, "Hello world!")
end

function click_play()
   local fd = vlc.net.connect_tcp( "172.19.23.42", 1377 )
   local data = "Vishnu"
   vlc.msg.dbg(fd);
   local pollfds = {}
   pollfds[fd] = vlc.net.POLLIN
   while data do
      vlc.osd.message(data)
      vlc.net.poll(pollfds)
      data = vlc.net.recv(fd, 10)
      vlc.msg.dbg(data);
	end
end
   -- vlc.msg.dbg(vlc.osd.register_channel());
   -- local data = "dhruv"
   -- vlc.osd.message(data, vlc.osd.register_channel(), "bottom", 2000);


function deactivate()
 vlc.msg.dbg("[remember pos] deact")
end

