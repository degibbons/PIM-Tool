%% frameLimits is a function which determines the inner and outer limits of the cropped frames in the data file
function [a,b,c,d] = frameLimits(filecontent)
R_C = [114 111 119 47 99 111 108 117 109 110]; %row/column in ASCII characters
R_C_Check = zeros(1,10);
R_C_Check(1) = 114; %Set the first character of the test vector to be 'r'
fileLength = length(filecontent);
i = 1;
ebrake = 0;
while ebrake == 0 %While the frame limits have not been determined, do the following
    if filecontent(i) == 114 %Check if the index is at an 'r'
        for j = 2:10 %If the index IS at an 'r', check if the folling characters spell out 'row/column'
            R_C_Check(j) = filecontent(i + j - 1); %by storing them in a test vector
        end
        if isequal(R_C,R_C_Check) %if the index is confirmed to be at 'row/column', advance the index to just past that
            i = i+10;
            while (filecontent(i)==9) || (filecontent(i)==13) || (filecontent(i)==10) 
                i = i+1; %While the index is at a Carriage Return, a New Line Feed, or a Horizontal Tab
            end %increment the index by 1. 
            [a,endIndex] = readTill(filecontent,i,9); %After passing the CRs, LFs, and Horizontal Tabs, read until 
            a = str2num(char(a)); %#ok<*ST2NM>        %the function hits a tab, returning the lower limit of the X axis
            while filecontent(endIndex+1) ~= 70 %While the index is not at 'F', read until the index reaches 'F'
                [b,endIndex]=readTill(filecontent,endIndex+1,9); %Store the read characters everytime this loops
            end
            b = str2num(char(b)); %The characters just before 'F' should be the upper X limit
            [~,endIndex]=readTill(filecontent,endIndex,10); %Advance the index until a New Line Feed is hit
            [c,endIndex]=readTill(filecontent,endIndex+1,9); %Then advance the index until a tab is hit
            c = str2num(char(c)); %The first read characters before the tab should be the lower Y limit
            while filecontent(endIndex+1) ~= 70 %While the index is not at at 'F', read until the index reaches 'F'
                [~,endIndex]=readTill(filecontent,endIndex+1,10);
            end
            endIndex = endIndex - 1; %Then decrement the index by 1
            while filecontent(endIndex) ~= 10 %Decrement the index by 1 until a New Line Feed is reached
                endIndex = endIndex - 1;
            end
            [d,~]=readTill(filecontent,endIndex,9); %Then read until a tab is hit.
            d = str2num(char(d)); %The stored characters should be the upper Y limit
            ebrake = 1; %After the above process is complete, break out of the loop and return the limits.
        end
    end
    if i < (fileLength-9) %If the index has not reached an 'r' and is not at the end of the file
        i = i+1; %Increment the index until it has reached an 'r'
    else
        ebrake = 1; %Otherwise, if the end of the file is reached, break out of the loop
    end
end
end
