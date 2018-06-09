function somUpdate(pattern, learningRate, neighborDist)
% ���������/�������� ��� ������� ��� ���������� ���� SOM
% ���� � ��������� ����������/���������� �� ����/����������� ���� SOM ����� ��� ����������
% ������� ��� Kohonen, � ����� ����� �wi = �ai(x-wi) 
% learningRate: � ������ ������� ���� �� ����� ���� ��� ������������ ��� ����� ��� SOM.
global IW N;

activations = somActivation(pattern, neighborDist); % returns which nodes 

for i=1:N
    IW(i,:) = IW(i,:) + learningRate * activations(i) * (pattern' - IW(i,:));
end