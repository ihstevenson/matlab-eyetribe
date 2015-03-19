function eyetribe_callback(obj,event,tet)

if obj.BytesAvailable>0
    tet.set_reply(fscanf(obj,'%c',obj.BytesAvailable))
end