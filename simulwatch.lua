-- Extension description
function descriptor()
 return { title = "Remember position" ;
  version = "1.0" ;
  author = "August" ;
  url = 'http://www.opensubtitles.org/';
  shortdesc = "Remember file pos";
  description = "Remember file position.\n"
    .. "Maintains a database of current play position for all files played." ;
  capabilities = { "input-listener" }
 }
end

function activate()
   vlc.msg.dbg("[remember pos] Welcome")
   local d = vlc.dialog( "My VLC Extension" )
   d:show()

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
   -- vlc.msg.dbg(vlc.osd.register_channel());
   -- local data = "dhruv"
   -- vlc.osd.message(data, vlc.osd.register_channel(), "bottom", 2000);
  
end

function deactivate()
 vlc.msg.dbg("[remember pos] deact")
end

