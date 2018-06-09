function [a] = somActivation(pattern, neighborDist)
%����������� ��� ������������� ���� SOM
%neighborDist: � �������� (��� ������ ��� SOM) ����� ��� ������ ��� ��������� ���� 
%�������� ��������� ���������� ��� ������� ������ (����� �������)
%a:������� Nx1 ��� ���������� ��� ��� ����� ��� �������������� ���� ��� �������� ���� SOM

% � �������� ��������� ���������� ��� �������������� ���� ��� �������� ��� SOM �� ����:
% � �������� ������� �������� ���� ������������� 1, �� �������� ��� ���������� ���������� 
% �� ����� (������ ����� ��� ���������� �� �������� <= neighborDist) ��������� ���� 0.5 
% ��� ���� �� ��������� �������� ����� ���� ������������� 0.
% � �������� ������ ��� ��������
% distances: ������� NxN ��� �������� ��� �������� ���� ������� ��� ���� ������� ��������

global N distances;

a = zeros(N,1);
output = (somOutput(pattern)); % � ����� ��������� ��� ������� ����������� ��� ��� ������
winner = find(output); % ������� �� �� �������� �������� (����� ���� ���)
for i=1:N
    if distances(winner,i) <= neighborDist %�������� winner ��� i-���� �������
        a(i) = 0.5;
    end
end    
a(winner) = 1;