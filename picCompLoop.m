clear;clc;
recycle('on');
global	index index1 index2 name1 name2
global  n1 n2 longName1 longName2 indexList fileObCache workDir
global flagPic1 flagPic2 flagSave flagDel1 flagDel2 flagClose
global flagRd1 flagRd2 indexFileOb fileOb
flagClose=0;
workDir='E:\0_Program\Python\WebDo\nm_nmcsym\';
% workDir='E:\0_Program\Python\WebDo\t\';
sType='jpg';
[fileOb,flagOb]=hereFile(workDir,sType);
folderList={fileOb.folder};
[uniqueFolder,iaFolder,icFolder]=unique(folderList);
uniqueFileOb=fileOb(iaFolder);
lenUnique=length(uniqueFileOb);
if 0
    for index=1:length(fileOb)
        newName=[num2str(index),'.jpg'];
        newLName=fullfile(fileOb(index).folder,newName);
        if ~exist(newLName,'file')
        movefile(fullfile(fileOb(index).folder,fileOb(index).name),newLName,'f');
        fileOb(index).name=newName;
        fprintf('\n%d/%d',index,length(fileOb));
        end
    end
end
if exist([workDir,'cmp.mat'],'file')
    fprintf('\nLoading cmp.mat ...');
    load([workDir,'cmp.mat']);
    if indexFileOb==0
        fileObCache=uniqueFileOb;
    else
        fileObCache=fileOb(strcmp(folderList,uniqueFileOb(indexFileOb)));
    end
    fprintf('\nLoad cmp.mat done.');
else
    fprintf('\nThere is not cmp.mat.\nCreating indexList ...');
    indexFileOb=0;
    fileObCache=uniqueFileOb;
    [rOb,cOb]=size(fileObCache);
    indexList=nchoosek(1:cOb,2);
    fprintf('\nCreating indexList done.');
end

while indexFileOb<=lenUnique
    [rL,cL]=size(indexList);
    while rL~=0 && flagClose==0
        index=randi(rL);
        index1=indexList(index,1);index2=indexList(index,2);
        name1=fileObCache(index1).name;name2=fileObCache(index2).name;
        [~,sname1,~]=fileparts(name1);[~,sname2,~]=fileparts(name2);
        n1=str2double(sname1);n2=str2double(sname2);
        longName1=fullfile(fileObCache(index1).folder,name1);
        longName2=fullfile(fileObCache(index2).folder,name2);
        pic1=imread(longName1);
        pic2=imread(longName2);
        clf;
        hFig=figure(1);
        hFig.Name=sprintf('length=%d',rL);
        %         subplot(1,2,1);h1=imshow(pic1);title(sname1);
        %         subplot(1,2,2);h2=imshow(pic2);title(sname2);
        subplot(1,2,1);h1=imshow(pic1);title(longName1);
        subplot(1,2,2);h2=imshow(pic2);title(longName2);
        %Button pic
        h1.ButtonDownFcn={@showCallBack1};
        h2.ButtonDownFcn={@showCallBack2};
        %Button Save
        hSave=uicontrol(hFig,'Style','pushbutton','string','SAVE');
        hSave.Callback={@saveIndexList};
        fPosition=get(gcf,'Position');
        wButton=60;hButton=20;
        xSaveB=fPosition(3)/10-wButton/2;ySaveB=fPosition(4)/13-hButton/2;
        hSave.Position=[xSaveB ySaveB wButton hButton];
        %button Delete
        hDel1=uicontrol(hFig,'Style','pushbutton','string','DEL Left');
        hDel1.Callback={@deleteLeft};
        hDel2=uicontrol(hFig,'Style','pushbutton','string','DEL Right');
        hDel2.Callback={@deleteRight};
        xDel1=fPosition(3)/3-wButton/2;yDel1=fPosition(4)/13-hButton/2;
        xDel2=fPosition(3)/3*2-wButton/2;yDel2=fPosition(4)/13-hButton/2;
        hDel1.Position=[xDel1 yDel1 wButton hButton];
        hDel2.Position=[xDel2 yDel2 wButton hButton];
        %Button Close
        hClose=uicontrol(hFig,'Style','pushbutton','string','Close');
        hClose.Callback={@closePro};
        xClose=fPosition(3)/10*9-wButton/2;yClose=fPosition(4)/13-hButton/2;
        hClose.Position=[xClose yClose wButton hButton];
        %Button Rd
        hRd1=uicontrol(hFig,'Style','pushbutton','string','Rd Left');
        hRd1.Callback={@rdLeft};
        hRd2=uicontrol(hFig,'Style','pushbutton','string','Rd Right');
        hRd2.Callback={@rdRight};
        xRd1=fPosition(3)/3-wButton/2;yRd1=fPosition(4)/13-hButton/2*3;
        xRd2=fPosition(3)/3*2-wButton/2;yRd2=fPosition(4)/13-hButton/2*3;
        hRd1.Position=[xRd1 yRd1 wButton hButton];
        hRd2.Position=[xRd2 yRd2 wButton hButton];
        flagPic1=0;flagPic2=0;flagSave=0;flagDel1=0;flagDel2=0;
        flagRd1=0;flagRd2=0;
        while ~(flagPic1||flagPic2||flagDel1||flagDel2||flagClose||flagRd1||flagRd2)
            drawnow;
        end
        [rL,cL]=size(indexList);
    end
    indexFileOb=indexFileOb+1;
end
fprintf('\nProgram end!');
close;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function showCallBack1(~,~)
global n1 n2 longName1 longName2 index index1 index2 name1 name2
global indexList fileObCache flagPic1 fileOb indexFileOb
fprintf('\nLeft Pic...');
if indexFileOb==0
    indexOb1=find(strcmp({fileOb.folder},fileObCache(index1).folder)==1);
    indexOb2=find(strcmp({fileOb.folder},fileObCache(index2).folder)==1);
    fileOb1=fileOb(indexOb1);
    fileOb2=fileOb(indexOb2);
    Len1=length(fileOb1);
    names12={fileOb1.name,fileOb2.name};
    [~,strName,~]=cellfun(@fileparts,names12,'UniformOutput',false);
    numName=cellfun(@str2num,strName,'UniformOutput',false);
    numName=sort(cell2mat(numName));
    lenNumName=length(numName);
    for ii=1:lenNumName
        if ii<=Len1
            destFile1=fullfile(fileOb1(ii).folder,[num2str(numName(ii)),'.jpg']);
            if ~exist(destFile1,'file')
                movefile(fullfile(fileOb1(ii).folder,fileOb1(ii).name),destFile1,'f');
                fileOb(indexOb1(ii)).name=[num2str(numName(ii)),'.jpg'];
                fileObCache(strcmp({fileObCache.name},fileOb1(ii).name)).name=[num2str(numName(ii)),'.jpg'];
            end
        else
            destFile2=fullfile(fileOb2(ii-Len1).folder,[num2str(numName(ii)),'.jpg']);
            if ~exist(destFile2,'file')
                movefile(fullfile(fileOb2(ii-Len1).folder,fileOb2(ii-Len1).name),destFile2,'f');                
                fileOb(indexOb2(ii-Len1)).name=[num2str(numName(ii)),'.jpg'];
                fileObCache(strcmp({fileObCache.name},fileOb2(ii-Len1).name)).name=[num2str(numName(ii)),'.jpg'];
            end
        end
    end
else
    if n1>n2
        if strcmp(fileObCache(index1).folder,fileObCache(index2).folder)
            movefile(longName2,[pwd,'\cache.jpg'],'f');
            movefile(longName1,fullfile(fileObCache(index1).folder,name2),'f');
            movefile([pwd,'\cache.jpg'],fullfile(fileObCache(index2).folder,name1),'f');
        else
            movefile(longName1,fullfile(fileObCache(index1).folder,name2),'f');
            movefile(longName2,fullfile(fileObCache(index2).folder,name1),'f');
        end
        nameCache=fileObCache(index1).name;
        fileObCache(index1).name=fileObCache(index2).name;
        fileObCache(index2).name=nameCache;
        indexList(indexList==index1)=index2;
        indexList(indexList==index2)=index1;
    end
end
indexList(index,:)=[];
flagPic1=1;
fprintf('\nLeft Pic Done!');
end
function showCallBack2(~,~)
global n1 n2 longName1 longName2 index index1 index2 name1 name2
global indexList fileObCache flagPic2 fileOb indexFileOb
fprintf('\nRight Pic...');
if indexFileOb==0
    indexOb1=find(strcmp({fileOb.folder},fileObCache(index1).folder)==1);
    indexOb2=find(strcmp({fileOb.folder},fileObCache(index2).folder)==1);
    fileOb1=fileOb(indexOb1);
    fileOb2=fileOb(indexOb2);
    Len2=length(fileOb2);
    names12={fileOb1.name,fileOb2.name};
    [~,strName,~]=cellfun(@fileparts,names12,'UniformOutput',false);
    numName=cellfun(@str2num,strName,'UniformOutput',false);
    numName=sort(cell2mat(numName));
    lenNumName=length(numName);
    for ii=1:lenNumName
        if ii<=Len2
            destFile2=fullfile(fileOb2(ii).folder,[num2str(numName(ii)),'.jpg']);
            if ~exist(destFile2,'file')
                movefile(fullfile(fileOb2(ii).folder,fileOb2(ii).name),destFile2,'f');
                fileOb(indexOb2(ii)).name=[num2str(numName(ii)),'.jpg'];
                fileObCache(strcmp({fileObCache.name},fileOb2(ii).name)).name=[num2str(numName(ii)),'.jpg'];
            end
        else
            destFile1=fullfile(fileOb1(ii-Len2).folder,[num2str(numName(ii)),'.jpg']);
            if ~exist(destFile1,'file')
                movefile(fullfile(fileOb1(ii-Len2).folder,fileOb1(ii-Len2).name),destFile1,'f');
                fileOb(indexOb1(ii-Len2)).name=[num2str(numName(ii)),'.jpg'];
                fileObCache(strcmp({fileObCache.name},fileOb1(ii-Len2).name)).name=[num2str(numName(ii)),'.jpg'];
            end
        end
    end
else
    if n2>n1
        if strcmp(fileObCache(index1).folder,fileObCache(index2).folder)
            movefile(longName2,[pwd,'\cache.jpg'],'f');
            movefile(longName1,fullfile(fileObCache(index1).folder,name2),'f');
            movefile([pwd,'\cache.jpg'],fullfile(fileObCache(index2).folder,name1),'f');
        else
            movefile(longName1,fullfile(fileObCache(index1).folder,name2),'f');
            movefile(longName2,fullfile(fileObCache(index2).folder,name1),'f');
        end
        nameCache=fileObCache(index1).name;
        fileObCache(index1).name=fileObCache(index2).name;
        fileObCache(index2).name=nameCache;
        indexList(indexList==index1)=index2;
        indexList(indexList==index2)=index1;
    end
end
indexList(index,:)=[];
flagPic2=1;
fprintf('\nRight Pic Done!');
end
function saveIndexList(~,~)
global indexList workDir flagSave
fprintf('\nSaving cmp.mat ...')
save([workDir,'cmp.mat'],'indexList','-ascii');
fprintf('\nSave cmp.mat Done.\n');
flagSave=1;
end
function deleteLeft(~,~)
global fileObCache indexList index1 longName1 flagDel1
fprintf('\ndeleteLeft...');
fileObCache(index1)=[];
[rCache,~]=find(indexList==index1);
indexList(rCache,:)=[];
rCache=find(indexList>index1);
for ii=rCache
    indexList(ii)=indexList(ii)-1;
end
delete(longName1);
flagDel1=1;
fprintf('\ndeleteLeft Done!');
end
function deleteRight(~,~)
global fileObCache indexList index2 longName2 flagDel2
fprintf('\ndeleteRight...');
fileObCache(index2)=[];
[rCache,~]=find(indexList==index2);
indexList(rCache,:)=[];
rCache=find(indexList>index2);
for ii=rCache
    indexList(ii)=indexList(ii)-1;
end
delete(longName2);
flagDel2=1;
fprintf('\ndeleteRight Done!');
end
function closePro(~,~)
global flagClose
global indexList workDir
fprintf('\nSaving cmp.mat ...')
save([workDir,'cmp.mat'],'indexList','-ascii');
fprintf('\nSave cmp.mat Done.\n');
flagClose=1;
end
function rdLeft(~,~)
global flagRd1
global fileObCache indexList index1
fprintf('\nrdLeft...');
folderName=fileObCache(index1).folder;
rmdir(folderName,'s');
folderList={fileObCache.folder};
boolList=strcmp(folderList,folderName);
rdIndex=find(boolList);
fileObCache(rdIndex)=[];
for index=1:length(rdIndex)
    [rIndex,~]=find(indexList(:,1)==rdIndex(index));
    indexList(rIndex,:)=[];
    [rIndex,~]=find(indexList(:,2)==rdIndex(index));
    indexList(rIndex,:)=[];
end
oldIndex=setdiff(rdIndex(1):length(folderList),rdIndex);
newIndex=rdIndex(1)-1+1:length(oldIndex);
for index=1:length(oldIndex)
    indexList(indexList==oldIndex(index))=newIndex(index);
end
flagRd1=1;
fprintf('\nrdLeft Done!');
end
function rdRight(~,~)
global flagRd2
global fileObCache indexList index2
fprintf('\nrdRight...');
folderName=fileObCache(index2).folder;
rmdir(folderName,'s');
folderList={fileObCache.folder};
boolList=strcmp(folderList,folderName);
rdIndex=find(boolList);
fileObCache(rdIndex)=[];
for index=1:length(rdIndex)
    [rIndex,~]=find(indexList(:,1)==rdIndex(index));
    indexList(rIndex,:)=[];
    [rIndex,~]=find(indexList(:,2)==rdIndex(index));
    indexList(rIndex,:)=[];
end
oldIndex=setdiff(rdIndex(1):length(folderList),rdIndex);
newIndex=rdIndex(1)-1+1:length(oldIndex);
for index=1:length(oldIndex)
    indexList(indexList==oldIndex(index))=newIndex(index);
end
flagRd2=1;
fprintf('\nrdRight Done!');
end