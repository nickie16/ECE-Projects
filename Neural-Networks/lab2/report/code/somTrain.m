function somTrain(patterns)
% SOM training
% patterns ������� DxP ��� �������� �� ������ ��� �������� ����������� ��� �� SOM.
% maxNeighborDist ������� �������� ��� ����������� ������ ��� ������������ ��������.
% orderLR � ������� ������ ������� ���� �� ordering ������ ��� �����������, ���������� ���� ����� �� 0.9.
% tuneND � �������� �������� ��� ��������������� ���� �� tuning ������ ��� �����������, 
% ������� ���� ����� �� 1
% orderSteps �� ������ ��� ������ ���� �� ordering ������ ��� ����������� �� ������������� �����������, ���������� ���� ����� �� 1000.
% tuneLR � ������ ������� ���� �� tuning ������ ��� �����������, ���������� ���� ����� �� 0.01.

global maxNeighborDist orderSteps tuneND orderLR tuneLR dY %IW distances
% QuestionData;
% data = QuestionPatterns;
%ordering phase
neighborDist = exp(linspace(log(maxNeighborDist), log(tuneND), orderSteps)); % �������� ������ ���������
learningRate = exp(linspace(log(orderLR), log(tuneLR), orderSteps)); % �������� ������ ������ �������

for i = 1:orderSteps
    for j = 1:dY
        somUpdate(patterns(:,j), learningRate(i), neighborDist(i)); % ��������
    end
    %i
%     figure(1);
%     plot2DSomData(IW, distances, data);
end

%tuning phase
for l=(orderSteps + 1):(4 * orderSteps) % ���������� �������� ����� ��� �������
    for j = 1:dY
        somUpdate(patterns(:,j), tuneLR, tuneND); % �������� ��� ������ ������� ��������
    end
    %l %in order to keep track of the current iteration
end