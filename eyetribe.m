% This is a light-weight matlab class for connecting to The Eyetribe
% tracker (http://theeyetribe.com/). Allows realtime access to gaze data
% using the JSON API and simultaneous recording to a file using matlab's
% native tcpip.
% 
% * Author:  Ian Stevenson
% * This work is licensed under a Creative Commons Attribution 4.0
%   International License (https://creativecommons.org/licenses/by/4.0/).

classdef eyetribe < handle
    properties
        et
        msg
        reply
        opt
        frame
        trackerProperties
        verbose=1
    end
    methods
        function obj = eyetribe(verbose)
            if nargin>0
                obj.verbose=verbose;
            end
            
            obj.opt = []; obj.opt.ParseLogical = 1;
            
            %%% Define JSON messages for the tracker...
            obj.msg = []; values = [];
            
            % Check if the system is running and calibrated...
            obj.msg.CheckConnection.category = 'tracker';
            obj.msg.CheckConnection.request  = 'get';
            obj.msg.CheckConnection.values   = {'push','iscalibrated'};
            
            % Get all info about the tracker...
            obj.msg.AssessConnection=obj.msg.CheckConnection;
            obj.msg.AssessConnection.values   = {'push','heartbeatinterval','version','trackerstate','framerate','iscalibrated','iscalibrating','calibresult','screenindex','screenresw','screenresh','screenpsyw','screenpsyh'};
            
            % Pull gaze data...
            obj.msg.PullFrame=obj.msg.CheckConnection;
            obj.msg.PullFrame.values   = {'push','frame'};
            
            % Start stream...
            values.push = true;
            values.version = 1;
            obj.msg.StartStream.category = 'tracker';
            obj.msg.StartStream.request  = 'set';
            obj.msg.StartStream.values   = values;
            
            % Stop stream...
            values.push = false;
            obj.msg.StopStream.category = 'tracker';
            obj.msg.StopStream.request  = 'set';
            obj.msg.StopStream.values   = values;
            
            %%% Initialize the connection...
            obj.et = tcpip('localhost',6555,'InputBufferSize',4096);
            obj.et.Terminator = 10;
            obj.et.BytesAvailableFcnMode = 'terminator';
            obj.et.BytesAvailableFcn = {'eyetribe_callback',obj};
            obj.et.TimerFcn = {'eyetribe_heartbeat'};
            obj.et.TimerPeriod = 2;
            obj.et.RecordDetail = 'verbose';
        end
        
        function status = connect(obj)
            fopen(obj.et)
            
            % Send JSON formatted commands to get trackerProperties
            if obj.verbose, fprintf('>> Initializing eye tracker...\n'); end
            m = savejson('',obj.msg.AssessConnection,obj.opt);
            fwrite(obj.et,m)
            if obj.verbose, fprintf('Sending...\n%s',m); end
            pause(0.05)
            if obj.verbose, fprintf('Received...\n%s',char(obj.reply)'); end
            obj.trackerProperties = loadjson(obj.reply);
            
            if obj.verbose
                if ~obj.trackerProperties.values.iscalibrated
                    fprintf('>> No calibration found, use the UI to calibrate...\n')
                else
                    fprintf('>> Calibration found...\n')
                end
                if ~obj.trackerProperties.values.push
                    fprintf('>> Currently in pull mode...\n')
                end
            end
            
            % Send JSON formatted commands to start push mode...
            if obj.verbose, fprintf('>> Setting to push mode...\n'); end
            m = savejson('',obj.msg.StartStream,obj.opt);
            fwrite(obj.et,m);
            if obj.verbose
                fprintf('Sending...\n%s',m);
                for i=1:25
                    fprintf('%s',obj.reply)
                    pause(1/obj.trackerProperties.values.framerate)
                end
            end
            rr = loadjson(obj.reply);
            if isfield(rr,'statuscode')
                if rr.statuscode==200
                    fprintf('>> Successfully set to push model, now streaming...\n')
                else
                    error('Something went wrong writing to push model...')
                end
            else
                fprintf('%s',obj.reply);
            end
        end
        
        function record_start(obj,fname)
            % Change tcpip properties to start recording...
            if nargin>1
                obj.et.RecordName = fname;
                obj.et.RecordMode = 'overwrite';
            else
                obj.et.RecordMode = 'index';
            end
            if obj.verbose, fprintf('>> Starting Recording: %s...\n',obj.et.RecordName); end
            record(obj.et,'on')
        end
        
        function record_stop(obj)
            % Change tcpip properties to stop recording...
            if obj.verbose, fprintf('>> Stopping Recording: %s...\n',obj.et.RecordName); end
            record(obj.et,'off')
        end
        
        function disconnect(obj)
            if obj.verbose, fprintf('>> Disconnecting...\n'); end
            fclose(obj.et)
            record(obj.et,'off')
        end
        
        function set_reply(obj,r)
            % Used with the eyetribe_callback to update the latest server response...
            obj.reply = r;
            
            % Update the latest data frame
            f = loadjson(obj.reply);
            if isfield(f,'values') & isfield(f.values,'frame')
                obj.frame = f.values.frame;
            end
        end
    end
end