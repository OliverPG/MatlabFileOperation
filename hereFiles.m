function [filenames,flag]=hereFiles(thedir)
%return file lists in the folder and its subfolders.
if isempty(thedir)
    thedir='./';
end
lists=dir(thedir);
n=length(lists);
filenames=struct('name','x','folder','x','date','x','bytes',1,'isdir',1,'datenum',1);
if n~=2
    flag=1;
    fn=1;
    for i=1:n
        if ~(strcmp(lists(i).name,'.')||strcmp(lists(i).name,'..'))
            switch lists(i).isdir
                case 0
                    filenames(fn).name=lists(i).name;
                    filenames(fn).folder=lists(i).folder;
                    filenames(fn).date=lists(i).date;
                    filenames(fn).bytes=lists(i).bytes;
                    filenames(fn).isdir=lists(i).isdir;
                    filenames(fn).datenum=lists(i).datenum;
%                     filenames(fn)=lists(i);
                    fn=fn+1;
                case 1
                    [hf,flagg]=hereFiles(fullfile(lists(i).folder,lists(i).name));
                    if flagg==1
                        nhf=length(hf);
                        for index=1:nhf
                            filenames(fn).name=hf(index).name;
                            filenames(fn).folder=hf(index).folder;
                            filenames(fn).date=hf(index).date;
                            filenames(fn).bytes=hf(index).bytes;
                            filenames(fn).isdir=hf(index).isdir;
                            filenames(fn).datenum=hf(index).datenum;
%                             filenames(fn)=hf(index);
                            fn=fn+1;
                        end
                    end
            end
        end
    end
else
    flag=0;
end
end