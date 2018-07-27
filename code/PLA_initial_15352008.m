load test.txt
load train.txt
load val.txt

[test_row,test_col]=size(test);
[train_row,train_col]=size(train);
[val_row,val_col]=size(val);

tmp_test=[ones(test_row,1) ,test(:,1:test_col-1)];
sign_test=test(:,test_col);

tmp_train=[ones(train_row,1) ,train(:,1:train_col-1)];
sign_train=train(:,train_col);

tmp_val=[ones(val_row,1) ,val(:,1:val_col-1)];
sign_val=val(:,val_col);

w=ones(1,val_col);%���ó�ʼW
count = sum( ( sign(tmp_val * w') - sign_val) == 0);
max=count;
for it = 1 : 273 %���õ�������
    for i = 1 : train_row
        if(sign(tmp_train(i,:) * w') ~= sign_train(i,:))   % �ܳ����ķ��� != ��ȷ����  ˵����ƥ��  ����ֱ��
            w =w + sign_train( i , : ) * tmp_train(i , : ); %���� w
        end
    end
    
    count = sum( ( sign(tmp_val * w') - sign_val) == 0);
    if(count > max) 
        max = count;
%       ʵ��*10 + ���  =      S   ���ٽ��ج�� ����for
%TP       1            1             11
%FN      1            -1             9
%TN     -1           -1           -11 
%FP     -1             1             -9
%                
         S=sign(tmp_val * w') + 10 * sign_val; %ԭ����ϱ�
         TP = sum(S( : ) == 11);                 
         FN = sum(S( : ) == 9);
         TN = sum(S( : ) == -11);
         FP = sum(S( : ) == -9);
         Accuracy = (TP + TN) / (TP + FP + TN + FN);
         Recall = TP / (TP + FN);
         Precision = TP / (TP + FP);
         F1 = (2 *  Precision * Recall) / (Precision + Recall);
         fprintf('\n��������:%d\t��ȷ����:%d\nAccuracy:%.6f\tRecall:%.6f\nPrecision:%.6f\tF1:%.6f\n',it,count,Accuracy,Recall,Precision,F1);    
    end  
end
ans_test=sign(tmp_test * w');
xlswrite('initial_ans.xlsx',ans_test);