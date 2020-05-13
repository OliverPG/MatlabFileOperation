function [filenames,flag]=hereFile(theDir,theExt)%(varargin)
%theDir,theExt
%return all the specified type file lists in the folder and its subfolders.
% hInput=inputParser;
% addParameter(hInput,'theDir','./')
% addParameter(hInput,'theExt','*')
% parse(hInput,varargin{:})
% % hInput.addParameter('theDir','./');
% % hInput.addParameter('theExt','*');
% % hInput.parse(varargin{:});

flag=0;
lists=dir(theDir);
n=length(lists);
filenames=struct('name','x','folder','x','date','x','bytes',1,'isdir',1,'datenum',1);
if n~=2
    fn=1;
    for i=1:n
        if ~(strcmp(lists(i).name,'.')||strcmp(lists(i).name,'..'))
            switch lists(i).isdir
                case 0
                    if strcmp(theExt,'*')
                        filenames(fn).name=lists(i).name;
                        filenames(fn).folder=lists(i).folder;
                        filenames(fn).date=lists(i).date;
                        filenames(fn).bytes=lists(i).bytes;
                        filenames(fn).isdir=lists(i).isdir;
                        filenames(fn).datenum=lists(i).datenum;
                        fn=fn+1;
                        flag=1;
                    else
                        [~,~,extCache]=fileparts(lists(i).name);
                        if strcmp(extCache,['.',theExt])
                            filenames(fn).name=lists(i).name;
                            filenames(fn).folder=lists(i).folder;
                            filenames(fn).date=lists(i).date;
                            filenames(fn).bytes=lists(i).bytes;
                            filenames(fn).isdir=lists(i).isdir;
                            filenames(fn).datenum=lists(i).datenum;
                            fn=fn+1;
                            flag=1;
                        end
                    end                            
                case 1
                    [hf,flagg]=hereFile(fullfile(lists(i).folder,lists(i).name),theExt);
                    if flagg==1
                        nhf=length(hf);
                        for index=1:nhf
                            filenames(fn).name=hf(index).name;
                            filenames(fn).folder=hf(index).folder;
                            filenames(fn).date=hf(index).date;
                            filenames(fn).bytes=hf(index).bytes;
                            filenames(fn).isdir=hf(index).isdir;
                            filenames(fn).datenum=hf(index).datenum;
                            fn=fn+1;
                        end
                        flag=1;
                    end
            end
        end
    end
else
    flag=0;
end
end