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

w=ones(1,val_col);%设置初始W
count = sum( ( sign(tmp_val * w') - sign_val) == 0);
max=count;
for it = 1 : 273 %设置迭代次数
    for i = 1 : train_row
        if(sign(tmp_train(i,:) * w') ~= sign_train(i,:))   % 跑出来的符号 != 正确符号  说明不匹配  调整直线
            w =w + sign_train( i , : ) * tmp_train(i , : ); %调整 w
        end
    end
    
    count = sum( ( sign(tmp_val * w') - sign_val) == 0);
    if(count > max) 
        max = count;
%       实际*10 + 结果  =      S   加速界的噩梦 抛弃for
%TP       1            1             11
%FN      1            -1             9
%TN     -1           -1           -11 
%FP     -1             1             -9
%                
         S=sign(tmp_val * w') + 10 * sign_val; %原理见上表
         TP = sum(S( : ) == 11);                 
         FN = sum(S( : ) == 9);
         TN = sum(S( : ) == -11);
         FP = sum(S( : ) == -9);
         Accuracy = (TP + TN) / (TP + FP + TN + FN);
         Recall = TP / (TP + FN);
         Precision = TP / (TP + FP);
         F1 = (2 *  Precision * Recall) / (Precision + Recall);
         fprintf('\n迭代次数:%d\t正确数量:%d\nAccuracy:%.6f\tRecall:%.6f\nPrecision:%.6f\tF1:%.6f\n',it,count,Accuracy,Recall,Precision,F1);    
    end  
end
ans_test=sign(tmp_test * w');
xlswrite('initial_ans.xlsx',ans_test);