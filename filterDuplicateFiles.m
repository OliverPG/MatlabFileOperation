clc;clear;tic;
boolName=1;
boolBytes=1;
boolDate=1;
view=1;%view=1, show me the duplicate files. view=0, remove the duplicate files.
filterDir='E:\LiMinQingHardDisk_190G\1\';
% filterDir='E:\GitHub\MatlabFileOperation\1\';
movetoDir=fullfile(filterDir,'duplicateFileCache');
recycle('on');
if exist(movetoDir,'dir')
    rmdir(movetoDir,'s');
    mkdir(movetoDir);
    fprintf('\n\tFiles in \n\t%s\n\tis removed!\n',movetoDir);    
else
    mkdir(movetoDir);
    fprintf('\n\tDirectory \n\t%s\n\tis created!\n',movetoDir);
end
% filterDir='E:\GitHub\MatlabFileOperation\1\';
fprintf('\n\thereFiles() running...');
fileObjs=hereFiles(filterDir);
fprintf('\n\tFile list get!');
nameList={fileObjs.name}';nameList1=nameList;
bytesList=[fileObjs.bytes]';bytesList1=bytesList;
datenumList=[fileObjs.datenum]';datenumList1=datenumList;
lenList=length(nameList);
ncmp=(rem(lenList,2)==0).*(lenList/2)+(rem(lenList,2)==1).*ceil(lenList/2);
dupIndex=[];
for i=1:ncmp
    nameList1=shiftN(nameList1,1,'up');
    bytesList1=shiftN(bytesList1,1,'up');
    datenumList1=shiftN(datenumList1,1,'up');
    cmpNames=cellcmp(nameList,nameList1);
    cmpBytes=~(bytesList1-bytesList);
    cmpDates=~(datenumList1-datenumList);
    cmpBool=(cmpNames|(~boolName))&(cmpBytes|(~boolBytes))&(cmpDates|(~boolDate));
    indexTrue=find(cmpBool==true);
    fprintf('\n\tFile cmp %d / %d',i,ncmp);
    if isempty(indexTrue)
        continue;
    else
    indexT=indexTrue+i;
    newDupIndex=[indexTrue,(indexT<=lenList).*indexT+(indexT>lenList).*rem(indexT,lenList)];
    dupIndex=[dupIndex;newDupIndex];
    end
end
if isempty(dupIndex)
    fprintf("\n\tNo duplicate file found!")
end
%simplify the duplicate list.
[rDup,cDup]=size(dupIndex);
dupIndexC=mat2cell(dupIndex,ones(rDup,1),cDup);
if numel(dupIndex)>numel(unique(dupIndex))
    dupN=numel(dupIndex)-numel(unique(dupIndex));
    countN=0;
    indexDup=2;
    while indexDup<=rDup
        indexDD=indexDup;
        while indexDD<=rDup
            indexDD1=indexDD-indexDup+1;
%             [indexDD,indexDD1]
%             [dupIndexC{indexDD},dupIndexC{indexDD1}]
            if numel(unique([dupIndexC{indexDD},dupIndexC{indexDD1}]))<numel(dupIndexC{indexDD})+numel(dupIndexC{indexDD1})
                uniqueCombine=unique([dupIndexC{indexDD},dupIndexC{indexDD-indexDup+1}]);
                dUnique=numel(dupIndexC{indexDD})+numel(dupIndexC{indexDD1})-numel(uniqueCombine);
                dupIndexC{indexDD1}=uniqueCombine;
                dupIndexC(indexDD)=[];
                indexDup=2;indexDD=indexDup;
                countN=countN+dUnique;                
            else
                indexDD=indexDD+1;
            end            
            [rDup,~]=size(dupIndexC);
            fprintf("\n\tCollate %d / %d.",countN,dupN);
            if countN==dupN
                break;
            end
        end
        indexDup=indexDup+1;  
        if countN==dupN
            break;
        end
    end      
end   
%move duplicate files to the Specified follder, or show these files.
lenCell=length(dupIndexC);
folderList={fileObjs.folder};
for indexCell=1:lenCell
    listCache=dupIndexC{indexCell};
    nDup=length(listCache);
    fprintf("\n***Duplicate files:");
    for indey=(2-view):nDup
        sourDir=fullfile(folderList{listCache(indey)},nameList{listCache(indey)});
        [pathname,simName,ext]=fileparts(nameList{listCache(indey)});
        toName=sprintf("%s(%d)%s",simName,indey,ext);
        txtName=sprintf("%s(%d)(from)%s",simName,indey,'.txt');
        destDir=fullfile(movetoDir,toName);
        dirTxt=fullfile(movetoDir,txtName);
        if view
            fprintf('\n\t%s',sourDir);
        else
            fp=fopen(dirTxt,'w');
            movefile(sourDir,destDir,'f');
            fprintf('\n\n\tMove \n\t%s\n\tto\n\t%s\n\t!',sourDir,destDir);
            fprintf(fp,'%s',sourDir);
            fclose(fp);
        end
    end
end   
fprintf('\nProgram Done!\n');
toc; 