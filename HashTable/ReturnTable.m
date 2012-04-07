%Divya Gunasekaran
%May 16, 2011

%Return the HashTable object associated with the given type of task 
%(string) or create a new one with the given size if none exists

function hashObj = ReturnTable(taskMap,taskType,tableSize)

%If the a HashTable for the given task type already exists
if(isKey(taskMap,taskType))
    %Return the HashTable
    hashObj = taskMap(taskType);
else
    %Else create a new HashTable for the given task type
    hashObj = HashTable(tableSize);
    taskMap(taskType) = hashObj;
    str = ['New HashTable created for ', taskType];
    disp(str);
end