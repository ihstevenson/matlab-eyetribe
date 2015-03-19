function eyetribe_heartbeat(obj,event)

msgHeartbeat.category = 'heartbeat';
msg = strrep(savejson('',msgHeartbeat),char(10),'');
msg = [strrep(msg,char(9),'') char(10)];
fprintf(obj,'%s',msg)