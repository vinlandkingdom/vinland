local version = "4.16.19" -- m.d.yy
http.Fetch("http://raw.githubusercontent.com/cobalt77/Custom-ULX-Commands/master/version.txt", function( body, len, headers, code)
  local nversion = body
  if nversion != version then
    MsgC(Color(0,191,255), "[ULX-Custom-Commands]", color_white, ": A new version is available on GitHub.\n")
  end
end)
