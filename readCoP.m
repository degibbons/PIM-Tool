%% readCoP extracts the center of pressure data at the end of the data file
function [CoPmat]=readCoP(filecontent,inIndex,frameDepth)
fileLength = length(filecontent);
CoPmat = zeros(frameDepth,5);
i = inIndex;
while i < fileLength %While the end of the file has not been reached
    if filecontent(i) == 88 %Check if the current indexed character is 'X', if yes
        if filecontent(i+1) == 40 && filecontent(i+2) == 102 && filecontent(i+3) == 116 %Check if the following characters are '(ft' 
            [~,i] = readTill(filecontent,i,49); %Advance the current index until a number 1 is hit
            [~,i] = readTill(filecontent,i,9); %Then advance the index until a Horizontal Tab is hit
            i = i+1; %Increment the index by 1
            for k = 1:frameDepth %From the first to the last frame (rows in this matrix)
                for j = 1:5 %Parse across each element in each column (5 columns)
                    [num,i] = readTill(filecontent,i,9); %Read until a Horizontal Tab is hit
                    CoPmat(k,j) = str2num(char(num));  %Assign the read number to it's proper index in the Center of Pressure matrix
                    i = i+1; %Increment the current index by 1, moving across the row
                end
                [~,i] = readTill(filecontent,i,10); %Read until the index reaches a New Line Feed, moving down to the next row
                if filecontent(i+1) == 9 %If the index has reached a horizontal tab
                    i = i+1; %Increment the index by 1
                    [~,i] = readTill(filecontent,i,10); %Then read until a New Line Feed is reached
                    i = i+1; %Repeat this process two more times
                    [~,i] = readTill(filecontent,i,10);
                    i = i+1;
                    [~,i] = readTill(filecontent,i,10);
                    i = i+1;
                    [~,i] = readTill(filecontent,i,9); %Then read until a Horizontal Tab is reached
                    i = i+1; %Move past the tab
                else
                    i = i+1; %If the index has not reached a Horizontal Tab
                    [~,i] = readTill(filecontent,i,9); %Read until a Horizontal Tab is reached
                    i = i+1; %Then increment past it
                end
            end
            i = fileLength; %Set the index to the file length so the loop is broken out of
        end
    end
    i = i+1; %Increment the current index until an 'X' is reached if it has not already been reached
end %Return the Center of Pressure matrix
end