marksVec=[repmat(5,1,19),repmat(4,1,9), 3];
weightVec=[7,7,4,4,3,7,4,3,4,7,3,3,3,4,3,6,4,3,4, 3,1,7,3,3,4,2,2,5, 4];
cumGPA=(sum(weightVec.*marksVec))/sum(weightVec);
